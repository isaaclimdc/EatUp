import os
from django.conf.urls import patterns, include, url
from django.conf import settings

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'eatupBackendProj.views.home', name='home'),
    # url(r'^eatupBackendProj/', include('eatupBackendProj.foo.urls')),

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