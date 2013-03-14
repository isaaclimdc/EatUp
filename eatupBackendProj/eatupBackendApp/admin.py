from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User

from eatupBackendApp.models import UserProfile, Event, Location

# Define an inline admin descriptor for UserProfile model
# see: https://docs.djangoproject.com/en/dev/topics/auth/customizing/#extending-the-existing-user-model
class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'UserProfile'

# Define a new User admin
class UserAdmin(UserAdmin):
    inlines = (UserProfileInline, )

# Re-register UserAdmin onto admin console
admin.site.unregister(User)
admin.site.register(User, UserAdmin)

# makes these models available on the admin console
admin.site.register(Event)
admin.site.register(Location)