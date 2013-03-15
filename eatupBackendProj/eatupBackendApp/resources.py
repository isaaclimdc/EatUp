from tastypie import fields, utils
from tastypie.resources import ModelResource
from django.contrib.auth.models import User
from eatupBackendApp.models import Event, Location, UserProfile



class UserResource(ModelResource):
    userprofile = fields.OneToOneField(
                        'eatupBackendApp.resources.UserProfileResource', 
                        'userprofile', full=True)
    #friends = 
    class Meta:
        queryset = User.objects.all()
        resource_name = 'user'
        fields = ["username", "first_name", "last_name", "userprofile"]
        
    def dehydrate(self, bundle):
        selfData = bundle.data
        profileData = bundle.data['userprofile'].data
        assert 'uid' not in selfData
        assert 'prof_pic' not in selfData
        
        selfData['facebook_uid'] = profileData['facebook_uid']
        selfData['prof_pic'] = profileData['prof_pic']
        
        # don't show extra user profile in the api data
        del(selfData['userprofile'])
        
        return bundle
        
# note: this provides simple extra data not in the Django user, do not expose
# this as a separate api resource        
class UserProfileResource(ModelResource):
    user = fields.OneToOneField(UserResource, 'user')

    class Meta:
        queryset = UserProfile.objects.all()
        resource_name = 'userprofile'         
        fields = ["facebook_uid", "prof_pic", "participating", "friends"]
        
        
class LocationResource(ModelResource):
    class Meta:
        queryset = Location.objects.all()
        resource_name = 'location'