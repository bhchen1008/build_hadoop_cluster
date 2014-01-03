#!/bin/bash

#change core-site.xml
echo "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>

<!-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://$1:9000</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/home/hadoop/hadoop_tmp</value>
  </property>
</configuration>" > ~/hadoop-0.20.2/conf/core-site.xml

#change mapred-site.xml
echo "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>

<!-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
    <name>mapred.job.tracker</name>
    <value>$1:9001</value>
  </property>
</configuration>" > ~/hadoop-0.20.2/conf/mapred-site.xml

#change masters
echo $1 > ~/hadoop-0.20.2/conf/masters
