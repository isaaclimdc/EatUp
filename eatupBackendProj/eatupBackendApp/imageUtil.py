import requests, re

from django.core.files import File
from django.core.files.temp import NamedTemporaryFile

IMAGE_TYPE_REGEX = re.compile(r"^image/(?P<type>(gif|jpeg|png))$", re.UNICODE)

def getImageUrlContentAndType(imageUrl):
    r = requests.get(imageUrl)
    contentType = r.headers['content-type']
    matchedType = IMAGE_TYPE_REGEX.match(contentType)
    if matchedType is None:
        raise ValueError("invalid image url; is content-type: %s" % contentType)
    
    fileType = matchedType.group('type')
    if fileType == 'jpeg':
        fileType = 'jpg'
        
    return r.content, fileType

# modifed from http://djangosnippets.org/snippets/2587/    
def saveImageFieldContents(model, imageFieldName, imageContents, fileName):
    # don't use delete=True due to Django giving a slightly different object 
    # definition for Windows: https://github.com/django/django/blob/master/django/core/files/temp.py
    img_temp = NamedTemporaryFile() 
                                    
    img_temp.write(imageContents)
    img_temp.flush()

    try:
        modelImage = getattr(model, imageFieldName)
    except AttributeError as e:
        print "invalid imagefield name %s" % imageFieldName
        raise e
    
    modelImage.save("%s" % (fileName), File(img_temp), save=True)
    