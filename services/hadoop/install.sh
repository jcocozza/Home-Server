#!/bin/bash
#
# Point of entry for hadoop installation
#
# Environment Variables
#   BASE_USER
#   HADOOP_MASTER_IP
#   HADOOP_USERNAME

machines=("$@")  ## List of ip addresses

python3 exports.py
hosts=$(cat hosts.txt)
source exports.sh
#echo $HADOOP_USERNAME


#for ipaddr in "${machines[@]}"; do
#    # append to hosts file on the remote machines
#    read -p "Press Enter to add hosts for $ipaddr"
#    ssh "$BASE_USER@$ipaddr" "echo '$hosts' | sudo tee -a /etc/hosts > /dev/null"
#done

for ipaddr in "${machines[@]}"; do
    read -p "Press Enter to put the config file on $ipaddr"
    scp exports.sh "$BASE_USER@$ipaddr:exports.sh"

    read -p "Press Enter to add the hadoop user to $ipaddr"
    # Add the hadoop user
    ssh "$BASE_USER@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/add_user.sh"

    read -p "Press Enter to share keys for $ipaddr"
    # share public keys with all other machines on the cluster
    # TODO THIS IS NOT RUNNING PROPERLY
    ssh "$BASE_USER@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/send_keys.sh ${machines[*]}"

    read -p "Press Enter to install hadoop for $ipaddr"
    # install hadoop
    ssh "$HADOOP_USERNAME@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/install.sh"
done

#ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "bash -s" < "services/hadoop/master/setup.sh"
# Setup hadoop
read -p "Press Enter to setup config for master $HADOOP_MASTER_IP"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/config_setup.sh"
read -p "Press Enter to distribute configuration to ${machines[*]}"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/distribute_configuration.sh ${machines[*]}"
read -p "Press Enter to format hdfs"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/format.sh"
