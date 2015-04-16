#!/bin/bash
#author : liyankun
#date : 20150412
#GET v2/{tenant_id}/ os-ipsans
#POST v2/{tenant_id}/ os-ipsans 
#GET v2/{tenant_id}/ os-ipsans/{ipsan_id}
#PUT v2/{tenant_id}/ os-ipsans/{ipsan_id}
#DELETE v2/{tenant_id}/ os-ipsans/{ipsan_id}
ID=$2
BODY='{"auth_method": "action", "ip": "192.168.2.204", "password": "111111", "port": "8774","size":  "10000", "status": "attached" , "target": "192.168.12.1.youyun.nvoa", "username": "youyun"}'
if [ $3 != '' ];then
    BODY=$3
fi
IP=192.168.2.204
PORT=8774

CONTENT_TYPE='application/json'
TOKEN_ID=$(keystone token-get | grep ' id' | awk '{print $4}')
TENANT_ID=$(keystone token-get | grep ' tenant_id' | awk '{print $4}')


function extension(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X GET -H "X-Auth-Token: ${TOKEN_ID}" http://${IP}:${PORT}/v2/${TENANT_ID}/extensions/instance-ipsans | python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi 
    return $ret
}

index(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X GET -H "X-Auth-Token: ${TOKEN_ID}" http://${IP}:${PORT}/v2/${TENANT_ID}/os-ipsans | python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi
    return $ret
   
}

create(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X POST -H "X-Auth-Token: ${TOKEN_ID} "  -H "Content-Type: $CONTENT_TYPE" http://${IP}:${PORT}/v2/${TENANT_ID}/os-ipsans -d "${BODY}" | python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi
    return $ret
}


show(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X GET -H "X-Auth-Token: ${TOKEN_ID}" http://${IP}:${PORT}/v2/${TENANT_ID}/os-ipsans/$ID   | python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi
    return $ret
}

instance_show(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X GET -H "X-Auth-Token: ${TOKEN_ID}" http://${IP}:${PORT}/v2/${TENANT_ID}/instance-ipsans/$ID   | python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi
    return $ret
}

delete(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X DELETE -H "X-Auth-Token: ${TOKEN_ID}" http://${IP}:${PORT}/v2/${TENANT_ID}/os-ipsans/$ID | python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi
    return $ret
}

update(){
    ret=0
    if [ $IP = '' ];then
        echo "IP we need don't found "
    fi
    if [ $PORT = '' ];then
        echo "PORT we need don't found "
    fi
    curl -v -X PUT -H "X-Auth-Token: ${TOKEN_ID} "  -H "Content-Type: $CONTENT_TYPE"  http://${IP}:${PORT}/v2/${TENANT_ID}/os-ipsans/$ID -d "${BODY}"| python -m json.tool
    if [ $? -eq 0 ];then
        ret=1
    fi
    return $ret
}



case "$1" in
  EXT)
    extension
    ;;
  SHOW_INSTANCE_IPSAN)
    instance_show
    ;;
  INDEX)
    index
    ;;
  CREATE)
    create
    ;;
  UPDATE)
    update
    ;;
  DELETE)
    delete
    ;;
  SHOW)
    show
    ;;
  *)
#    echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
    exit 0
esac

