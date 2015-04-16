#'''
#author: liyankun
#version: 0.1
#'''

import webob
from webob import exc 

from nova import db
from nova import  exception
from nova.api.openstack import extensions
from nova.openstack.common import log as logging
from nova.api.openstack import wsgi
from nova.api.openstack import xmlutil
from nova.openstack.common.gettextutils import _

authorize = extensions.extension_authorizer('compute', 'ipsans') 

LOG = logging.getLogger(__name__)

class IpsanController(wsgi.Controller):
    """the Ipsan API Controller declearation"""
    def index(self, req):
        ipsans={}
        context = req.environ['nova.context']
        authorize(context)
        try:
            ipsan = db.ipsan_get_all(context)
        except:
            raise webob.exc.HTTPNotFound(explanation="ipsan not found")
        
        ipsans['ipsan'] = ipsan
        return ipsans
    
    def create(self, req, body):
        ipsans = {}
        context = req.environ['nova.context']
        obj = body
        authorize(context)
        # create a ipsan object from body
        
        values=obj
        LOG.debug(_("create ipsan device22222222222222222222222222%s."), body, context=context)
        try:
            ipsan = db.ipsan_create(context, values)
        except:
            raise
        ipsans['ipsan'] = ipsan
        return ipsans
    
    def show(self, req, id):
        ipsans = {}
        context = req.environ['nova.context']
        authorize(context)
        
        #LOG.debug(_("show ipsan device#2222222222222222222222222222222222222222%s."), id, context=context)
#         LOG.debug(_("Instance %s is not attached."), id)
#         LOG.audit(_("Detach volume %s"), id, context=context)
        try:
            ipsan = db.ipsan_get_by_ipsan_id(context, id)
        except:
            raise webob.exc.HTTPNotFound(explanation="ipsan not found")
        
        ipsans["ipsan"] = ipsan
        return ipsans
        
    def update(self, req, id, body):
        ipsans = {}
        context = req.environ['nova.context']
        values = body
        authorize(context)
        #values = body
        LOG.debug(_("update ipsan device222222222222222222222222222222222222222%s."), body, context=context)
        try:
            ipsan = db.ipsan_update(context, id, values)
        except:
            raise webob.exc.HTTPException
        ipsans['ipsan'] = ipsan
        return ipsans
    def delete(self,req, id):
        context = req.environ['nova.context']
        authorize(context)
        #LOG.debug(_("delete ipsan device22222222222222222222222222222222222222222%s."), id, context=context)
        try:
            db.ipsan_delete(context, id)
        except:
            raise webob.exc.HTTPException()
        return webob.Response(status_int=202)
    
class Ipsans(extensions.ExtensionDescriptor):
    """Ipsans ExtensionDescriptor implementation
    GET v2/{tenant_id}/ os-ipsans
    POST v2/{tenant_id}/ os-ipsans 
    GET v2/{tenant_id}/ os-ipsans/{ipsan_id}
    PUT v2/{tenant_id}/ os-ipsans/{ipsan_id}
    DELETE v2/{tenant_id}/ os-ipsans/{ipsan_id}"""
    
    name = "ipsan"
    alias = "os-ipsans"
    namespace = "www.youyun.com"
    update = "2015-04-07"
    
    def get_resources(self):
        """ipsan support"""
      #  member_actions = {"action": "GET"}
      #  collection_actions={'update': 'PUT'}
        #resources = [extensions.ResourceExtension('os-ipsans', IpsanController(),collection_actions=collection_actions, member_actions=member_actions)]
        resources = [extensions.ResourceExtension('os-ipsans', IpsanController())]
        
        return resources
