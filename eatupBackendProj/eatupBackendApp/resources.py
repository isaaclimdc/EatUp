from tastypie import fields, utils
from tastypie.resources import ModelResource
from eatupBackendApp.models import Event, Location, AppUser

class EventResource(ModelResource):
    participants = fields.ManyToManyField('eatupBackendApp.resources.InlineAppUserResource',
                                          'participants', full=True)
    locations = fields.ManyToManyField('eatupBackendApp.resources.LocationResource',
                                       'locations', full=True)
    
    class Meta:
        queryset = Event.objects.all()
        resource_name = 'event'
        
class InlineEventResource(ModelResource):
    class Meta:
        queryset = Event.objects.all()
        resource_name = 'inline_event'
        
class AppUserResource(ModelResource):
    friends = fields.ManyToManyField('eatupBackendApp.resources.InlineAppUserResource', 
                                     'friends', full=True)
    participating = fields.ManyToManyField('eatupBackendApp.resources.InlineEventResource', 
                                           'participating', full=True)
    
    class Meta:
        queryset = AppUser.objects.all()
        resource_name = 'user'
        
class InlineAppUserResource(ModelResource):
    class Meta:
        queryset = AppUser.objects.all()
        resource_name = 'inline_user'

class LocationResource(ModelResource):
    class Meta:
        queryset = Location.objects.all()
        resource_name = 'location'