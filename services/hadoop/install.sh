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


for ipaddr in "${machines[@]}"; do
    # append to hosts file on the remote machines
    read -p "Press Enter to add hosts for $ipaddr"
    ssh "$BASE_USER@$ipaddr" "echo '$hosts' | sudo tee -a /etc/hosts > /dev/null"
done

for ipaddr in "${machines[@]}"; do
    # add the exports.sh file to the remote machine
    scp exports.sh "$BASE_USER@$ipaddr:exports.sh"

    # Add the hadoop user
    ssh "$BASE_USER@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/add_user.sh"
    scp exports.sh "$HADOOP_USERNAME@$ipaddr:exports.sh"
done

read -p "Press Enter to begin second process"
keyfile="/home/$HADOOP_USERNAME/.ssh/hadoop"
for ipaddr in "${machines[@]}"; do
    read -p "Press Enter to share keys for $ipaddr"
    # share public keys with all other machines on the cluster
    # send key to all other ips
    ssh "$BASE_USER@$ipaddr" "source exports.sh; sudo -u $HADOOP_USERNAME ssh-keygen -t rsa -f $keyfile -N ''; sudo chmod 600 $keyfile"
    for ip in "${machines[@]}"; do
        if [[ "$ip" != "$ipaddr" ]]; then
            ssh -t $HADOOP_USERNAME@$ipaddr "ssh-copy-id -i $keyfile.pub $HADOOP_USERNAME@$ip;"
        fi
    done

    read -p "Press Enter to install hadoop for $ipaddr"
    # install hadoop
    ssh -t "$HADOOP_USERNAME@$ipaddr" "sudo apt-get update;"
    ssh -t "$HADOOP_USERNAME@$ipaddr" "sudo apt install openjdk-11-jdk;"
    ssh "$HADOOP_USERNAME@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/install.sh"
    ssh "$HADOOP_USERNAME@$ipaddr" "sudo mv hadoop $HADOOP_LOCATION"
done

#ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "bash -s" < "services/hadoop/master/setup.sh"
# Setup hadoop
read -p "Press Enter to setup config for master $HADOOP_MASTER_IP"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/config_setup.sh"

for ipaddr in "${machines[@]}"; do
    ssh "$HADOOP_USERNAME@$ipaddr" "sudo chown $HADOOP_USERNAME:root -R $HADOOP_LOCATION"
    ssh "$HADOOP_USERNAME@$ipaddr" "sudo chmod g+rwx -R $HADOOP_LOCATION"
done

read -p "Press Enter to distribute configuration to ${machines[*]}"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/distribute_configuration.sh ${machines[*]}"
read -p "Press Enter to format hdfs"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/format.sh"
