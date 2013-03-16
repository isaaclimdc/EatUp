import os, re
from django.conf import settings
from django.http import (HttpResponse, HttpResponseBadRequest, 
                         HttpResponseServerError, HttpResponseForbidden, 
                         HttpResponseRedirect, HttpResponseNotFound)
from eatupBackendApp.models import Event, AppUser, Location
from eatupBackendApp.json_response import json_response
from annoying.functions import get_object_or_None 
    
@json_response()    
def getUser(request):
    if 'uid' not in request.REQUEST:
        return {'error': 'missing id argument'}
    
    uid = request.REQUEST['uid']
    if not uid.isdigit():
        return {'error': 'invalid user'}
        
    foundUser = get_object_or_None(AppUser, uid=uid)
    if foundUser is None:
        return {'error': 'invalid user'}
    else:
        return foundUser.getDictForJson()
    
@json_response()    
def getEvent(request):
    if 'eid' not in request.REQUEST:
        return {'error': 'missing id argument'}
    
    eid = request.REQUEST['eid']
    if not eid.isdigit():
        return {'error': 'invalid event'}
    
    foundEvent = get_object_or_None(Event, eid=eid)
    if foundEvent is None:
        return {'error': 'invalid event'}
    else:
        return foundEvent.getDictForJson()
    
    