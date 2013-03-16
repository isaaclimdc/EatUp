import os, re
from django.conf import settings
from django.http import (HttpResponse, HttpResponseBadRequest, 
                         HttpResponseServerError, HttpResponseForbidden, 
                         HttpResponseRedirect)
from eatupBackendApp.models import Event, AppUser, Location
from eatupBackendApp.json_response import json_response
    
@json_response()    
def getUser(request):
    if 'uid' not in request.REQUEST:
        return {'error': 'unable to retrieve user; no uid given'}
    
    allUsers = {}
    for appUser in AppUser.objects.all():
        allUsers[appUser.pk] = appUser.getDictForJson()
    return allUsers
    
@json_response()    
def getEvent(request):
    if 'eid' not in request.REQUEST:
        return {'error': 'unable to retrieve event; no eid given'}
    
    allEvents = {}
    for event in Event.objects.all():
        allEvents[event.pk] = event.getDictForJson()
    return allEvents
    
    