#http://djangosnippets.org/snippets/2869/
try:
    import json
except ImportError:
    import simplejson as json
    
from django.http import HttpResponse

class json_response(object):
    def __init__(self, login_required = False, ajax_required = False):
        self.login_required = login_required
        self.ajax_required = ajax_required
    def __call__(self, func):
        class_args = self
        def decorator(request, *args, **kwargs):
            if class_args.login_required and not request.user.is_authenticated():
                objects = {
                    "status": "error",
                    "msg": "User not authenticated"
                }
            elif class_args.ajax_required and not request.is_ajax():
                objects = {
                    "status": "error",
                    "msg": "Request gone wrong :("
                }
            else:
                objects = func(request, *args, **kwargs)
            
            if isinstance(objects, HttpResponse):
                return objects
            try:
                data = json.dumps(objects)
                if 'callback' in request.REQUEST:
                    # a jsonp response!
                    data = '%s(%s);' % (request.REQUEST['callback'], data)
                    return HttpResponse(data, "text/javascript")
            except:
                print "json dump error, returning single string"
                data = json.dumps(str(objects))
            return HttpResponse(data, "application/json")
        
        return decorator