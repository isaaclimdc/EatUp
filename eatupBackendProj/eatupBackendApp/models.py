from django.db import models
from django.conf import settings
from django.db.models.signals import post_save

# update this if moving from django 1.4 to 1.5
from django.contrib.auth.models import User

class Event(models.Model):
    title = models.CharField(max_length=128)
    date_time = models.DateTimeField(verbose_name="Date & Time")
    description = models.TextField(blank=True)
    participants = models.ManyToManyField(User)
    locations = models.ManyToManyField('Location')
    
    
class UserProfile(models.Model):
    user = models.OneToOneField(User)
    first_name = models.CharField(max_length=128, blank=True)
    last_name = models.CharField(max_length=128, blank=True)
    
    # TODO: flesh out with info and/or integrate with facebook
    prof_pic = models.ImageField(upload_to=settings.PROFILE_PICS_FOLDER)
    
    participating = models.ManyToManyField(Event, blank=True) 
    friends = models.ManyToManyField(User, related_name="friends", blank=True) 
    
    
class Location(models.Model):
    lat = models.FloatField()
    lng = models.FloatField()
    friendly_name = models.CharField(max_length=128)
    link = models.URLField()
    num_votes = models.PositiveIntegerField()
    
    
# the lines below register UserProfiles to be auto-created when Users are
def create_user_profile(sender, instance, created, **kwargs):  
    if created:  
       UserProfile.objects.get_or_create(user=instance)
       
post_save.connect(create_user_profile, sender=User) 