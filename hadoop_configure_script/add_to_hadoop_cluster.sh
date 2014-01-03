#!/bin/bash
#add_to_hadoop_cluster.sh
#add this node to hadoop cluster

function read_value {
    echo "Please enter a value for $2:"
    read $1
    if [ "${!1}" == "" ]; then
        echo "Invalid value. Exiting"
        exit 1
    fi
}

#add master to hosts
read_value master_ip "master_ip"			#get master_ip
read_value master_hostname "master_hostname"		#get master_hostname	

echo "add master's hostname and ip to hosts."
echo -e ${master_ip}'\t'${master_hostname} >> hosts	

echo "add its hostname and ip to hosts."
hadoop_configure_script/add_self_to_hosts.sh

echo "create hostname"
cat /etc/hostname > hadoop_configure_script/hostname
ls -l hadoop_configure_script/hostname

#create add_slave.sh
echo "create add_slave.sh"
echo "#!/bin/bash

cd ~/hadoop-0.20.2/conf
cat tmp >> slaves" > hadoop_configure_script/add_slave.sh
chmod +x hadoop_configure_script/add_slave.sh
ls -l hadoop_configure_script/add_slave.sh

echo "create slave_host"
ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | awk 'BEGIN{ORS=""}{print $0"\t";}' >> hadoop_configure_script/hosts      #get self_ip

filename='/etc/hostname'
exec < $filename

while read line
do
        echo $line >> hadoop_configure_script/hosts
done
ls -l hadoop_configure_script/hosts

#create add_slave_to_master's_hosts
echo "create add_slave_to_master's_hosts"
echo "#!/bin/bash

cat ~/hadoop-0.20.2/conf/slave_host >> /etc/hosts
" > hadoop_configure_script/add_slave_host_to_master.sh
chmod +x hadoop_configure_script/add_slave_host_to_master.sh
ls -l hadoop_configure_script/add_slave_host_to_master.sh

#send hostname and add_slave.sh to master
echo "send slave_hostname."
scp hadoop_configure_script/hostname ${master_hostname}:~/hadoop-0.20.2/conf/tmp

echo "send add_slave.sh"
scp hadoop_configure_script/add_slave.sh ${master_hostname}:~/hadoop-0.20.2/conf/add_slave.sh

echo "send slave_host."
scp hadoop_configure_script/hosts ${master_hostname}:~/hadoop-0.20.2/conf/slave_host

echo "send add_slave_host_to_master.sh"
scp hadoop_configure_script/add_slave_host_to_master.sh ${master_hostname}:~/hadoop-0.20.2/conf/add_slave_host_to_master.sh

echo "add slave to slave_conf"
ssh ${master_hostname} ~/hadoop-0.20.2/conf/add_slave.sh

echo "add slave_host to hosts"
ssh ${master_hostname} ~/hadoop-0.20.2/conf/add_slave_host_to_master.sh
                        
ssh ${master_hostname} rm -rf ~/hadoop-0.20.2/conf/tmp
ssh ${master_hostname} rm -rf ~/hadoop-0.20.2/conf/slave_host
ssh ${master_hostname} rm -rf ~/hadoop-0.20.2/conf/add_slave.sh
ssh ${master_hostname} rm -rf ~/hadoop-0.20.2/conf/add_slave_host_to_master.sh

echo "remove hosts and hostname"
rm -rf hadoop_configure_script/host*

echo "remove add_slave.sh and add_slave_host_to_master.sh"
rm -rf hadoop_configure_script/add_slave*


