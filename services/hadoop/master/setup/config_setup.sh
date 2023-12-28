#!/bin/bash
#
# Setup config files for hadoop
# This script takes in a list of node (host)names, where the first one is the master node, the rest are workers
#
# Environment Variables
#   HADOOP_LOCATION

# basic configuration

# core-site.xml
master_name="$1"
core_site="<configuration>
<property>
<name>fs.defaultFS</name>
<value>hdfs://$master_name:9000</value>
</property>
</configuration>"

#echo "$core_site" | sudo tee -a "$HADOOP_LOCATION/etc/hadoop/core-site.xml" > /dev/null
echo "$core_site" >> "$HADOOP_LOCATION/etc/hadoop/core-site.xml"



# hdfs-site.xml
hdfs_site="<configuration>
<property>
<name>dfs.namenode.name.dir</name><value>$HADOOP_LOCATION/data/nameNode</value>
</property>
<property>
<name>dfs.datanode.data.dir</name><value>$HADOOP_LOCATION/data/dataNode</value>
</property>
<property>
<name>dfs.replication</name>
<value>2</value>
</property>
</configuration>"

#echo "$hdfs_site" | sudo tee -a "$HADOOP_LOCATION/etc/hadoop/hdfs-site.xml" > /dev/null
echo "$hdfs_site" >> "$HADOOP_LOCATION/etc/hadoop/hdfs-site.xml"

# workers
shift # Remove the master node name from the list of arguments

# Append slave nodes to a workers file
for node in "$@"; do
    echo "$node" >> $HADOOP_LOCATION/etc/hadoop/workers
done

#echo "Slave nodes appended to workers file."


# yarn-site.xml
yarn_site="<configuration>
<property>
<name>yarn.resourcemanager.hostname</name>
<value>$master_name</value>
</property>
</configuration>"

#echo "$yarn_site" | sudo tee -a "$HADOOP_LOCATION/etc/hadoop/yarn-site.xml" > /dev/null
echo "$yarn_site" >> "$HADOOP_LOCATION/etc/hadoop/yarn-site.xml"