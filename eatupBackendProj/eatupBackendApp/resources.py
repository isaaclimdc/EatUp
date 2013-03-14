from tastypie.resources import ModelResource
from django.contrib.auth.models import User
from eatupBackendApp.models import Event, Location, UserProfile

'''
class UserResource(ModelResource):
    userprofile = fields.ToOneField('eatupBackendApp.resources.UserProfileResource', 'userprofile', full=True)
    class Meta:
        queryset = User.objects.all()
        resource_name = 'user'

class UserProfileResource(ModelResource):
    user = fields.ToOneField(UserResource, 'user')

    class Meta:
        queryset = UserProfile.objects.all()
        resource_name = 'userprofile'        
'''        
        
class LocationResource(ModelResource):
    class Meta:
        queryset = Location.objects.all()
        resource_name = 'location'