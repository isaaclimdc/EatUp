from django.contrib import admin
from eatupBackendApp.models import AppUser, Event, Location

class EventLocationsInline(admin.StackedInline):
    model = Location
    extra = 0
  
class EventAdmin(admin.ModelAdmin):
    inlines = [EventLocationsInline]
    list_display = ('eid', 'title', 'date_time')

class AppUserAdmin(admin.ModelAdmin):
    list_display = ('uid', 'last_name', 'first_name')
  
class LocationAdmin(admin.ModelAdmin):
    list_display = ('id', 'lat', 'lng', 'friendly_name', 'eventHere')
  
# makes these models available on the admin console
admin.site.register(Event, EventAdmin)
admin.site.register(AppUser, AppUserAdmin)
admin.site.register(Location, LocationAdmin)