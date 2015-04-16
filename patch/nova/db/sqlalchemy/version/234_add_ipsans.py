#create ipsans table
#author : liyankun
#date : 20150415

from migrate.changeset import UniqueConstraint
from migrate import ForeignKeyConstraint
from sqlalchemy import Boolean, BigInteger, Column, DateTime, Enum, Float
from sqlalchemy import dialects
from sqlalchemy import ForeignKey, Index, Integer, MetaData, String, Table
from sqlalchemy import Text
from sqlalchemy.types import NullType

from nova.openstack.common.gettextutils import _
from nova.openstack.common import log as logging

LOG = logging.getLogger(__name__)


def upgrade(engine):
    meta = MetaData()
    meta.bind = engine
    instances = Table('instances', meta, autoload=True)
    ipsans = Table('ipsans', meta,
            Column('created_at', DateTime(timezone=False)),
            Column('updated_at', DateTime(timezone=False)),
            Column('deleted_at', DateTime(timezone=False)),
            Column('id', Integer, primary_key=True, nullable=False),
            Column('target', String(length=255), nullable=False),
            Column('ip', String(length=36), nullable=False),
            Column('port', String(length=36), nullable=False),
            Column('auth_method', String(length=36)),
            Column('username', String(length=36)),
            Column('password', String(length=36)),
            Column('size', String(length=36), nullable=False),
            Column('status', String(length=36), nullable=False),
            Column('instance_uuid', Integer,ForeignKey('instances.id')),
            Column('device_name', String(length=36)),
            Column('deleted', Integer),
            mysql_engine='InnoDB',
            mysql_charset='utf8'
    )
    try:
        ipsans.create()
    except Exception:
        LOG.exception(_('Exception while creating table.'))    


 
def downgrade(engine):
    pass
