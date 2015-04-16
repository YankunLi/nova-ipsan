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

authorize = extensions.extension_authorizer('compute', 'instanceIpsans') 

LOG = logging.getLogger(__name__)

class InstanceIpsanController(wsgi.Controller):
    """the Ipsan API Controller declearation"""
    def show(self, req, id):
        instanceIpsans = {}
        context = req.environ['nova.context']
        authorize(context) 
        try:
            ipsan = db.ipsan_get_by_instance_id(context, id)
        except:
            raise webob.exc.HTTPNotFound(explanation="ipsan not found")
        
        instanceIpsans["ipsan"] = ipsan
        return instanceIpsans
    
class InstanceIpsans(extensions.ExtensionDescriptor):
    """Ipsans ExtensionDescriptor implementation"""
    
    name = "instance-ipsan"
    alias = "instance-ipsans"
    namespace = "www.shanghai.com"
    update = "2015-04-07"
    
    def get_resources(self):
        """ipsan support"""
       # member_actions = {"show": "GET"}
        #collection_actions={'update': 'PUT'}
        #resources = [extensions.ResourceExtension('os-ipsans', IpsanController(),collection_actions=collection_actions, member_actions=member_actions)]
        resources = [extensions.ResourceExtension('instance-ipsans', InstanceIpsanController())]
        
        return resources
