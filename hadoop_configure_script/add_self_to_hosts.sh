#!/bin/bash
#add_self_to_hosts.sh
#add self to hosts
ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | awk 'BEGIN{ORS=""}{print $0"\t";}' >> hosts      #get self_ip

#add hostname to /etc/hosts
#cat /etc/hostname > hostname                            #get hostname

filename='/etc/hostname'
exec < $filename

while read line
do
        echo $line >> hosts
done

sudo mv hosts /etc/hosts
