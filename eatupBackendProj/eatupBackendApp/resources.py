from tastypie import fields, utils
from tastypie.resources import ModelResource
from eatupBackendApp.models import Event, Location, AppUser


        
class LocationResource(ModelResource):
    class Meta:
        queryset = Location.objects.all()
        resource_name = 'location'