from django.contrib import admin
from eatupBackendApp.models import AppUser, Event, Location



# makes these models available on the admin console
admin.site.register(Event)
admin.site.register(AppUser)
admin.site.register(Location)