#/bin/bash
#author:liyankun
#date:20150415
alias | grep  -q cp
if [ $? -eq 0 ]; then
    unalias cp
fi
alias | grep  -q mv
if [ $? -eq 0 ]; then
    unalias mv
fi
alias | grep  -q rm
if [ $? -eq 0 ]; then
    unalias rm
fi

CURR_PATH=$(cd "$(dirname "$0")"; pwd)
echo $CURR_PATH
BACK_END=/opt
PRIVILEGES=644
USER=root
GROUP=root
SERVICE_DIR=/usr/lib/python2.6/site-packages

cat $CURR_PATH/config.ini | while read line
do
    ll=$line
    #echo $ll
    echo $ll | grep '#' >> /dev/null
    if [ $? -eq 0 ];then
        continue
    fi

    old=$(echo $ll | awk -F '=' '{print $1}')
    echo $old  
    new=$(echo $ll | awk -F '=' '{print $2}')
    echo $CURR_PATH/patch$new

    if [ ${new} = '' ];then
        echo "warning the config ile format must be example: /opt/abc.txt=/mnt/abc.txt"
        exit 1
    fi

    if [ -f $old -a -f $CURR_PATH/patch$new ];then
        echo "change "
        old_file_dir=${old%/*}
        echo $old_file_dir
        if [ -d $BACK_END$old_file_dir ];then
            mv $old $BACK_END$old_file_dir/
            cp  $CURR_PATH/patch$new $old_file_dir/
            chown $USER:$GROUP $old_file_dir/${new##*/}
            chmod $PRIVILEGES $old_file_dir/${new##*/}
        else
            mkdir -p $BACK_END$old_file_dir/
            mv $old $BACK_END$old_file_dir/
            cp  $CURR_PATH/patch$new $old_file_dir/
            chown $USER:$GROUP $old_file_dir/${new##*/}
            chmod $PRIVILEGES $old_file_dir/${new##*/}
        fi
    fi
done
cp $CURR_PATH/patch/nova/db/sqlalchemy/version/234_add_ipsans.py $SERVICE_DIR/nova/db/sqlalchemy/migrate_repo/versions/
cp $CURR_PATH/patch/nova/api/contrib/ipsans.py  $SERVICE_DIR/nova/api/openstack/compute/contrib/
cp $CURR_PATH/patch/nova/api/contrib/instanceIpsans.py  $SERVICE_DIR/nova/api/openstack/compute/contrib/
