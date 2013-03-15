import os
from django.conf.urls import patterns, include, url
from django.conf import settings
from tastypie.api import Api
from eatupBackendApp.resources import LocationResource, UserResource

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

# register api resources
v1_api = Api(api_name='v1')
v1_api.register(LocationResource())
v1_api.register(UserResource())

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'eatupBackendProj.views.home', name='home'),
    # url(r'^eatupBackendProj/', include('eatupBackendProj.foo.urls')),
    (r'^api/', include(v1_api.urls)),
    
    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)

# this pattern allows django to serve media files in production
urlpatterns += patterns('',
    url(r'^media/profilePics/(?P<path>.*)$', 'django.views.static.serve',
        {'document_root': settings.PROFILE_PICS_ROOT}),
)

# this pattern allows django to serve static files in production
urlpatterns += patterns('', 
    url(r'^static/(?P<path>.*)$', 'django.views.static.serve',
        {'document_root': settings.STATIC_ROOT }),
)