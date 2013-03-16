from django.db import models
from django.conf import settings
import time
try:
    import json
except ImportError:
    import simplejson as json
from django.forms.models import model_to_dict
from django.core import serializers

class JsonableModel(models.Model):
    class Meta:
        abstract = True
    def getDictForJson(self, inline=False):
        if hasattr(self, 'inlineFields'):
            inlineFields = self.inlineFields
        else:
            inlineFields = set()
            
        if hasattr(self, 'idName'):
            idName = self.idName
        else:
            idName = None
    
        # get default serialized json dictionary for object instance
        # note that because the serializer requires an iterable and we only have
        # a single instance, we must create a singleton tuple for serialization,
        # then get it back through index[0]
        jsonDict = json.loads(serializers.serialize('json', (self,)))[0]
        assert 'fields' in jsonDict
        
        # replace with dictionary object's actual field names and their values
        jsonDict = jsonDict['fields']
        
        # make sure to use .keys, since we'll be editing the dictionary as we go
        for fieldName in jsonDict.keys():
            fieldVal = getattr(self, fieldName)
            if fieldName in inlineFields:
                if inline:
                    del(jsonDict[fieldName])
                else:
                    # map each instance of a related model to a parsed version 
                    # for inline-embedding
                    jsonDict[fieldName] = map(
                        lambda obj: obj.getDictForJson(inline=True), 
                        fieldVal.all()
                    )
                    
                    # ex: in Events, we essentially do
                    # d['participants'] = map(<...>, self.participants.all())
        if idName is not None:
            assert idName not in jsonDict
            jsonDict[idName] = self.pk
        return jsonDict

class Event(JsonableModel):
    eid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=128)
    date_time = models.DateTimeField(verbose_name="Date & Time")
    description = models.TextField(blank=True)
    participants = models.ManyToManyField('AppUser')
    locations = models.ManyToManyField('Location')
    
    inlineFields = {'participants', 'locations'}
    idName = "eid"
    
    def __unicode__(self):
        return u"%s at %s" % (self.title, self.date_time)

        
# ugh, super insecure, but since we insisted on facebook authentication and
# a native mobile app without enough time to learn how to do that,
# here's a simplified version for the prototype where it relies on the
# front end to correctly authenticate
# note that this doesn't use Django's User model at all
class AppUser(JsonableModel):
    uid = models.PositiveIntegerField(primary_key=True)
    
    first_name = models.CharField(max_length=128)
    last_name = models.CharField(max_length=128)
    
    prof_pic = models.ImageField(upload_to=settings.PROFILE_PICS_FOLDER,
                                 blank=True)
    
    participating = models.ManyToManyField(Event, blank=True,
                                           through=Event.participants.through) #define through so that both sides of relationship show up in admin form
    friends = models.ManyToManyField('self', related_name="friends", blank=True) 
    
    inlineFields = {'participating', 'friends'}
    idName = "uid"
    
    def __unicode__(self):
        return u'%s, %s' % (self.last_name, self.first_name)
        

class Location(JsonableModel):
    lat = models.FloatField()
    lng = models.FloatField()
    friendly_name = models.CharField(max_length=128, blank=True)
    link = models.URLField(blank=True)
    num_votes = models.PositiveIntegerField(default=0)
    
    def __unicode__(self):
        return u"%.3f, %.3f: %s" % (self.lat, self.lng, self.friendly_name)
        
        
