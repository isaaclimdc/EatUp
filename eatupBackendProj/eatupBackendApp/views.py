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
   
    
@json_response()   
def createEvent(request):
    # change this to POST if it turns out ios apps don't have to worry about
    # cross domain policy
    dataDict = request.REQUEST
    
    newTitle = dataDict.get("title", "")
    newDesc = dataDict.get("description", "")
    newTimestamp = parseIntOrNone(dataDict.get("timestamp"))
    newParticipantIds = dataDict.getlist("participants[]")
    newLocations = getDictArray(dataDict, "locations")
    
    # parse out new date time
    if newTimestamp is None:
        return createErrorDict('invalid timestamp')
    # account for fact that javascript timestamps are in milliseconds while
    # python's are in seconds
    newTimestamp /= 1000
    
    try:
        newDateTime = datetime.datetime.fromtimestamp(newTimestamp, utc)
    except ValueError:
        return createErrorDict('invalid timestamp')
    
    # parse out list of participant users
    if len(newParticipantIds) == 0:
        return createErrorDict('events require at least one participant')
    else:
        participants = []
        for id in newParticipantIds:
            parsedId = parseIntOrNone(id)
            if parsedId is None:
                return createErrorDict('invalid format of partipicant ID %s' % id)
            foundUser = get_object_or_None(AppUser, pk=parsedId)
            if foundUser is None:
                return createErrorDict('invalid partipicant ID %s' % parsedId)
            participants.append(foundUser)
                    
    
    return {'status':'TODO: validating locations'}
    
    