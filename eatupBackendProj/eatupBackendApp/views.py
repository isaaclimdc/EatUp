import os, re, time, datetime, urllib, math, requests
from django.conf import settings
from django.http import (HttpResponse, HttpResponseBadRequest, 
                         HttpResponseServerError, HttpResponseForbidden, 
                         HttpResponseRedirect, HttpResponseNotFound)
from eatupBackendApp.models import Event, AppUser, Location
from eatupBackendApp.json_response import json_response
import eatupBackendApp.imageUtil as imageUtil
from annoying.functions import get_object_or_None 
from django.shortcuts import render
from django.utils.timezone import utc

try:
    import json
except ImportError:
    import simplejson as json

### helper functions ###
  
def parseIntOrNone(intStr):
    '''(string): integer or None

    attempts to parse the input into an integer, returns None if it fails
    '''  
    try:
        output = int(intStr)
    except:
        output = None
    return output    
    
def parseFloatOrNone(floatStr):
    '''(string): float or None

    attempts to parse the input into a non-NaN float, returns None if it fails
    '''  
    try:
        output = float(floatStr)
        assert not math.isnan(output)
    except:
        output = None
    return output
    
def createErrorDict(errorMsg="an error occurred"):
    '''(string): dict

    returns a simple dictionary with an "error" entry
    '''  
    return {'error': errorMsg}
    
def jsonDictOfSpecificObj(modelClass, pk, errorMsg="invalid"):
    '''(models.Model subclass, <primary key type>, string): dict
    
    finds the model object with the specific given primary key and returns its
    JSON-friendly dictionary representation
    returns an error dictionary if no such object exists
    '''
    foundObj = get_object_or_None(modelClass, pk=pk)
    if foundObj is None:
        return createErrorDict(errorMsg)
    else:
        return foundObj.getDictForJson()
    
def getDictArray(reqDict, name):
    '''(request dictionary, string): dictionary list
    
    modified from http://stackoverflow.com/a/5498916
    takes the weirdly-parsed request.REQUEST dict from some django request that
    was passed a list of json objects
    and parses it into a list of Python dictionaries
    
    name is the name of the json property whose value was a list of objects
    
    NOTE: only works for arrays of one-level objects
    
    always returns an array (returns an empty list if given invalid name)
    '''
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
   

def locationDictToObject(locDict, allowCreation=True, allowEditing=False):
    ''' (dict, bool, bool): Location, string

    validates and turns a dictionary of some location's attributes into its
    respective Location object
    
    if allowCreation is True and no preexisting id is given, 
    creates a new Location and returns it (up to caller to save to the database)
     - this will require data for all required fields
     
    if allowCreation is False and no preexisting id is given, returns an error
    
    if a preexisting id is given and allowEditing is True, 
    edits the Location to match the given attributes
    
    if a preexisting id is given and allowEditing is False, returns an error
    
    returns errors if validation fails at any point 
    (up to caller to save changes)
    
    return two values:
      - a Location object, if validation passes, None otherwise
      - None if validation passes, an error message otherwise
      
    NOTE: does not handle saving the eventHere relationship, this is left to 
    the caller
    '''
    # first, parse out the location's attributes
    latitude = locDict.get('lat')
    longitude = locDict.get('lng')
    friendlyName = locDict.get("friendly_name")
    link = locDict.get("link")
    numVotes = locDict.get("num_votes", 0)
    # ensure that the number of votes is a nonnegative int
    if type(numVotes) != int:
        numVotes = parseIntOrNone(numVotes)
        if numVotes is None or numVotes < 0:
            return (None, "invalid number of votes given")
            
    # search for ID of preexisting location object        
    id = parseIntOrNone(locDict.get('id', ""))
    existingLoc = get_object_or_None(Location, id=id)
    outputLoc = None
    # if preexisting object, edit its attributes
    if existingLoc is not None:
        if(allowEditing):
            existingLoc.lat = latitude
            existingLoc.lng = longitude
            existingLoc.friendly_name = friendlyName
            existingLoc.link = link
            existingLoc.num_votes = numVotes
            outputLoc = existingLoc
        else:
            return (None, "location ID %d already exists" % id)
    # if no preexisting object and creation is allowed, create new Location
    elif allowCreation:
        outputLoc = Location(lat=latitude, lng=longitude, 
                             friendly_name=friendlyName,
                             link=link, num_votes=numVotes)
    # otherwise, return error
    else:
        return (None, ("location id not given, "
                       "new location creation not allowed"))
                       
    # validate model before returning it                       
    try:
        outputLoc.full_clean()
    except Exception as e:
        return (None, str(e))
    return (outputLoc, None)
        
def parseElems(unparsedElems, parseFn, elemName="element"):
    ''' ('a list, 'a -> 'b, string): ('b list or None, string or None)
    
    applies the given parsing function to every element in the given list
    
    returns two values:
      - the list of parsed elements if no error occurs, None otherwise
      - None if no error occurs, an error message otherwise
    '''
    parsedElems = []
    for elem in unparsedElems:
        try: 
            parsedElem = parseFn(elem)
        except:
            return (None, "unable to parse %s %s" % (elemName, elem))
        parsedElems.append(parsedElem)
    return (parsedElems, None)
    
    
def idsToObjects(parsedIdList, objType, objName="object"):
    ''' (<id type> list, models.Model subclass, string): model instance list
    
    takes a list of already-parsed ids (ie: already converted from strings)
    and creates a list of model objects with those ids
    returns two values as a tuple: 
    - the list of objects, if they are all found (None otherwise)
    - None if no error occurs, otherwise an error message
    '''
    objects = []
    for parsedId in parsedIdList:
        foundObj = get_object_or_None(objType, pk=parsedId)
        if foundObj is None:
            return (None, 'invalid %s ID %r' % (objName, parsedId))
        objects.append(foundObj)
    return (objects, None)       
    
def parseIdsToObjects(unparsedIds, objType, parseFn, objName="object"):
    ''' ('a list, models.Model subclass, 'a -> id type, string):
        model instance list
    
    takes a list of unparsed ids, parses it into a list of ids, then
    creates a list of model objects with those ids
    
    returns two values as a tuple: 
    - the list of objects if no parsing or locating error occurs, None otherwise
    - None if no error occurs, otherwise an error message
    '''
    parsedIds, error = parseElems(unparsedIds, parseFn, 
                                  elemName=("%s ID" % objName))
    if error:
        return (None, error)
        
    objects, error = idsToObjects(parsedIds, objType, objName=objName)
    if error:
        return (None, error)
        
    return (objects, None)
        
    
### url-view functions ###    

def showIndex(request):
    return render(request, 'index.html', {})    
    
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
    
@json_response()   
def createEvent(request):
    # change this to POST if it turns out ios apps don't have to worry about
    # cross domain policy
    dataDict = request.REQUEST
    
    newHostId = dataDict.get("host")
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
    
    # parse out host ID to the AppUser object
    if newHostId is None:
        return createErrorDict("host user's ID is required")
    parsedHostId = parseIntOrNone(newHostId)
    if parsedHostId is None:
        return createErrorDict("invalid format for host user ID given")
    hostUser = get_object_or_None(AppUser, uid=parsedHostId)
    if hostUser is None:
        return createErrorDict("invalid host user ID given")
    
    # parse out list of participant users
    if len(newParticipantIds) == 0:
        return createErrorDict('events require at least one participant '
                               '(ie: the creator)')
    else:
        eventParticipants, error = parseIdsToObjects(newParticipantIds, AppUser,
                                                     lambda s: int(s), 
                                                     objName="participant")
        if error:
            return createErrorDict(error)
                    
    # for every location data, create/edit locations as needed and stored the 
    # new object, but don't save to the database
    # during the initial runthrough. If we hit an error, don't save any changes
    # and just return an error JSON. Only after everything passes do we save to
    # the database
    eventLocations = []
    for i in xrange(len(newLocationsData)):
        locationData = newLocationsData[i]
        newLocation, error = locationDictToObject(locationData, 
                                                  allowCreation=True,
                                                  allowEditing=False)
        if error:
            return createErrorDict("invalid location data at index %d: %s" 
                                   % (i, error))
        eventLocations.append(newLocation)
        
    # save all location changes
    for loc in eventLocations:
        loc.save()
            
    # finally create the event object itself        
    newEvent = Event(title=newTitle, description=newDesc,
                     date_time=newDateTime, host=hostUser)
    try:
        newEvent.full_clean()
    except Exception as e:
        return createErrorDict(str(e))
    # created object must be saved before editing ManyToMany fields
    newEvent.save()
    newEvent.participants.add(*eventParticipants)
    newEvent.locations.add(*eventLocations)
            
    return {'status':'ok',
            'eid': newEvent.pk}
    
    
@json_response()   
def createUser(request):
    dataDict = request.REQUEST
    
    if 'uid' not in dataDict:
        return createErrorDict("facebook uid is required")
    
    uid = parseIntOrNone(dataDict['uid'])
    if uid is None or uid < 0:
        return createErrorDict("invalid uid given; incorrect format")
    elif get_object_or_None(AppUser, uid=uid) is not None:
        return createErrorDict("cannot create user %d, already exists" % uid)
        
    # check for valid profile picture url, if given    
    profPicUrl = dataDict.get("prof_pic_url")
    profPicContent = None
    profPicFiletype = None
    if profPicUrl:
        try:
            profPicContent, profPicFiletype = \
                imageUtil.getImageUrlContentAndType(profPicUrl)
        except ValueError as e:
            return createErrorDict(str(e))
        
    firstName = dataDict.get("first_name", "")
    lastName = dataDict.get("last_name", "")
    
    # parse participating IDs and friend IDs into lists of Events and AppUsers,
    # respectively
    participatingIds = dataDict.getlist('participating[]')
    friendIds = dataDict.getlist('friends[]')
    
    userEvents, error = parseIdsToObjects(participatingIds, Event,
                                          lambda s: int(s), 
                                          objName="participating")
    if error:
        return createErrorDict(error)
        
    userFriends, error = parseIdsToObjects(friendIds, AppUser, lambda s: int(s),
                                       objName="friend")
    if error:
        return createErrorDict(error)                                  
    
    # finally create the AppUser object itself        
    newUser = AppUser(uid=uid, first_name=firstName, last_name=lastName
                      # TODO: profile picture handling
                     )
    # validate the new AppUser object                     
    try:
        newUser.full_clean()
    except Exception as e:
        return createErrorDict(str(e))
        
    # created object must be saved before editing ManyToMany fields
    newUser.save()
    newUser.participating.add(*userEvents)
    newUser.friends.add(*userFriends)
    
    # save profile picture
    if profPicContent and profPicFiletype:
        filename = "profpic_%d.%s" % (newUser.uid, profPicFiletype)
        try:
            imageUtil.saveImageFieldContents(newUser, 'prof_pic', 
                                             profPicContent, filename)
        except Exception as e:
            errorDict = createErrorDict(str(e))
            errorDict['uid'] = newUser.pk
            return errorDict
    
    return {'status': 'ok',
            'uid': newUser.pk}