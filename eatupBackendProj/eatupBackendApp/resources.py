from tastypie import fields, utils
from tastypie.resources import ModelResource
from eatupBackendApp.models import Event, Location, AppUser

class EventResource(ModelResource):
    eid = fields.IntegerField(readonly=True)
    participants = fields.ManyToManyField('eatupBackendApp.resources.AppUserResource',
                                          'participants', full=True)
    locations = fields.ManyToManyField('eatupBackendApp.resources.LocationResource',
                                       'locations', full=True)
    
    class Meta:
        queryset = Event.objects.all()
        resource_name = 'event'
        
class AppUserResource(ModelResource):
    uid = fields.IntegerField(readonly=True)
    friends = fields.ManyToManyField('self', 'friends', full=True)
    participating = fields.ManyToManyField('eatupBackendApp.resources.EventResource', 
                                           'participating', full=True) 
    
    class Meta:
        queryset = AppUser.objects.all()
        resource_name = 'user'

class LocationResource(ModelResource):
    class Meta:
        queryset = Location.objects.all()
        resource_name = 'location'