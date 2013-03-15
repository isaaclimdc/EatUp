from django.db import models
from django.conf import settings

class Event(models.Model):
    eid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=128)
    date_time = models.DateTimeField(verbose_name="Date & Time")
    description = models.TextField(blank=True)
    participants = models.ManyToManyField('AppUser')
    locations = models.ManyToManyField('Location')
    
    def __unicode__(self):
        return u"%s at %s" % (self.title, self.date_time)


# ugh, super insecure, but for the sake of saving time
# note that this doesn't use Django's User model at all
class AppUser(models.Model):
    uid = models.PositiveIntegerField(primary_key=True)
    
    first_name = models.CharField(max_length=128)
    last_name = models.CharField(max_length=128)
    
    prof_pic = models.ImageField(upload_to=settings.PROFILE_PICS_FOLDER,
                                 blank=True)
    
    participating = models.ManyToManyField(Event, blank=True) 
    friends = models.ManyToManyField('self', related_name="friends", blank=True) 
    
    def __unicode__(self):
        return u'%s, %s' % (self.last_name, self.first_name)


class Location(models.Model):
    lat = models.FloatField()
    lng = models.FloatField()
    friendly_name = models.CharField(max_length=128, blank=True)
    link = models.URLField(blank=True)
    num_votes = models.PositiveIntegerField(blank=True)
    
    def __unicode__(self):
        return u"%.3f, %.3f: %s" % (self.lat, self.lng, self.friendly_name)
