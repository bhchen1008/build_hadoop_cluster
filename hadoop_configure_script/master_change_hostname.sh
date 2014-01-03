#!/bin/bash
#change_hostname.sh

function read_value {
    echo "Please enter a value for $2:"
    read $1
    if [ "${!1}" == "" ]; then
        echo "Invalid value. Exiting"
        exit 1
    fi
}

#get hostname from user
read_value hostname "hostname"

#change hostname
echo $hostname > hostname

sudo mv hostname /etc/hostname

sudo hostname -F /etc/hostname

#change_hadoop_conf
hadoop_configure_script/change_master_hadoop_conf.sh $hostname
