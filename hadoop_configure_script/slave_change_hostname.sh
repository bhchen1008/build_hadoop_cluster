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

read_value hostname "hostname"

echo $hostname > hostname

sudo mv hostname /etc/hostname

sudo hostname -F /etc/hostname

