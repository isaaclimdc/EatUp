import os, re, time, datetime, urllib
from django.conf import settings
from django.http import (HttpResponse, HttpResponseBadRequest, 
                         HttpResponseServerError, HttpResponseForbidden, 
                         HttpResponseRedirect, HttpResponseNotFound)
from eatupBackendApp.models import Event, AppUser, Location
from eatupBackendApp.json_response import json_response
from annoying.functions import get_object_or_None 
from django.shortcuts import render
from django.utils.timezone import utc
from django.http import QueryDict
import math

try:
    import json
except ImportError:
    import simplejson as json

def showIndex(request):
    return render(request, 'index.html', {})
    
def parseIntOrNone(intStr):
    try:
        output = int(intStr)
    except:
        output = None
    return output    
    
def parseFloatOrNone(floatStr):
    try:
        output = float(floatStr)
        assert not math.isnan(output)
    except:
        output = None
    return output
    
def createErrorDict(errorMsg="an error occurred"):
    return {'error': errorMsg}
    
# gets the parsed for-JSON dictionary of the object with the given primary key
def jsonDictOfSpecificObj(modelClass, pk, errorMsg="invalid"):
    foundObj = get_object_or_None(modelClass, pk=pk)
    if foundObj is None:
        return createErrorDict(errorMsg)
    else:
        return foundObj.getDictForJson()
    
@json_response()    
def getUser(request):
    if 'uid' not in request.REQUEST:
        return createErrorDict('missing id argument')
    
    uid = parseIntOrNone(request.REQUEST['uid'])
    if uid is None:
        return createErrorDict('invalid user')
        
    return jsonDictOfSpecificObj(AppUser, uid, errorMsg="invalid user")
    
@json_response()    
def getEvent(request):
    if 'eid' not in request.REQUEST:
        return createErrorDict('missing id argument')
    
    eid = parseIntOrNone(request.REQUEST['eid'])
    if eid is None:
        return createErrorDict('invalid event')
    
    return jsonDictOfSpecificObj(Event, eid, errorMsg="invalid event")       
    
    
# modified from http://stackoverflow.com/a/5498916
# takes the weirdly-parsed dictionary django turns a list of dictionaries into
# and parses it into a list of Python dictionaries
# NOTE: only works for arrays of one-level objects
# always returns an array (returns an empty list if given invalid name)
def getDictArray(reqDict, name):
    dic = {}
    for k in reqDict.keys():
        if k.startswith(name):
            rest = k[len(name):]

            # split the string into different components
            parts = [p[:-1] for p in rest.split('[')][1:]
            id = int(parts[0])

            # add a new dictionary if it doesn't exist yet
            if id not in dic:
                dic[id] = {}

            # add the information to the dictionary
            dic[id][parts[1]] = reqDict.get(k)
    
    # because dic is a dictionary of listindeces mapped to the actual 
    # sub-dictionary at that index, return the list of sub-dictionaries instead
    keyVals = sorted(dic.items())
    return map(lambda (i, subDict): subDict, keyVals)
   
# validates and turns a dictionary of some location's attributes into its
# respective Location object
# if allowCreation is True and no preexisting id is given, 
# creates a new Location and returns it (up to caller to save to the database)
# make sure to instantiate the object instead of using <object>.objects.create
#  - this will require data for all required fields
# if allowCreation is False and no preexisting id is given, raises an error
# if a preexisting id is given, edits the Location to match the given attributes
# throws errors if validation fails at any point (up to caller to save changes)
def locationDictToObject(locDict, allowCreation=True):
    print locDict
    latitude = locDict.get('lat')
    longitude = locDict.get('lng')
    friendlyName = locDict.get("friendly_name")
    link = locDict.get("link")
    numVotes = locDict.get("num_votes", 0)
    if type(numVotes) != int:
        numVotes = parseIntOrNone(numVotes)
        if numVotes is None or numVotes < 0:
            raise ValueError("invalid number of votes given")
            
    id = locDict.get('id', "")
    id = parseIntOrNone(id)
    existingLoc = get_object_or_None(Location, id=id)
    if existingLoc is not None:
        print "editing existing"
        existingLoc.lat = latitude
        existingLoc.lng = longitude
        existingLoc.friendly_name = friendlyName
        existingLoc.link = link
        existingLoc.num_votes = numVotes
        existingLoc.full_clean()
        return existingLoc
    elif allowCreation:
        print "Creating new"
        newLoc = Location(lat=latitude, lng=longitude, 
                          friendly_name=friendlyName,
                          link=link, num_votes=numVotes)
        newLoc.full_clean()
        return newLoc
    else:
        raise Exception("location id not given, "
                        "new location creation not allowed")
    
@json_response()   
def createEvent(request):
    # change this to POST if it turns out ios apps don't have to worry about
    # cross domain policy
    dataDict = request.REQUEST
    
    newTitle = dataDict.get("title", "")
    newDesc = dataDict.get("description", "")
    newTimestamp = parseIntOrNone(dataDict.get("timestamp"))
    newParticipantIds = dataDict.getlist("participants[]")
    newLocationsData = getDictArray(dataDict, "locations")
    
    # parse out new date time
    if newTimestamp is None:
        return createErrorDict('invalid timestamp')
    # account for fact that javascript timestamps are in milliseconds while
    # python's are in seconds
    newTimestamp /= 1000
    
    # turn timestamp into an actual datetime object
    try:
        newDateTime = datetime.datetime.fromtimestamp(newTimestamp, utc)
    except ValueError:
        return createErrorDict('invalid timestamp')
    
    # parse out list of participant users
    if len(newParticipantIds) == 0:
        return createErrorDict('events require at least one participant '
                               '(ie: the creator)')
    else:
        eventParticipants = []
        # parse each user id into its corresponding preexisting AppUser
        # (errors if invalid id or not an existing AppUser)
        for id in newParticipantIds:
            parsedId = parseIntOrNone(id)
            if parsedId is None:
                return createErrorDict('invalid format of partipicant ID %s' % id)
            foundUser = get_object_or_None(AppUser, pk=parsedId)
            if foundUser is None:
                return createErrorDict('invalid partipicant ID %s' % parsedId)
            eventParticipants.append(foundUser)
                    
    # for every location data, create/edit locations as needed and stored the 
    # new object, but don't save to the database
    # during the initial runthrough. If we hit an error, don't save any changes
    # and just return an error JSON. Only after everything passes do we save to
    # the database
    eventLocations = []
    for i in xrange(len(newLocationsData)):
        locationData = newLocationsData[i]
        try:
            newLocation = locationDictToObject(locationData, allowCreation=True)
        except Exception as e:
            return createErrorDict("invalid location data at index %d: %s" 
                                   % (i, e))
        eventLocations.append(newLocation)
    # save all location changes
    for loc in eventLocations:
        loc.save()
            
    # finally create the event object itself        
    newEvent = Event.objects.create(title=newTitle, description=newDesc,
                                    date_time=newDateTime)
    newEvent.participants.add(*eventParticipants)
    newEvent.locations.add(*eventLocations)
            
    return {'status':'ok',
            'eid': newEvent.pk}
    