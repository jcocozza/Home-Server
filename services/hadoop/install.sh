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

echo "Adding Hadoop User to each machine..."
for ipaddr in "${machines[@]}"; do
    # add the exports.sh file to the remote machine
    scp exports.sh "$BASE_USER@$ipaddr:exports.sh"

    # Add the hadoop user
    ssh "$BASE_USER@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/add_user.sh"
    scp exports.sh "$HADOOP_USERNAME@$ipaddr:exports.sh"
done

read -p "Press Enter to hosts to .ssh/config file for passwordless login to hadoop user"
ssh-keygen -t rsa -f ~/.ssh/id_tmp -N ''
touch ~/.ssh/config
for ipaddr in "${machines[@]}"; do
    config="Host $ipaddr
    HostName $ipaddr
    IdentityFile ~/.ssh/id_tmp"

    echo "$config" >> ~/.ssh/config

    if ! ssh-copy-id -i ~/.ssh/id_tmp.pub  "$HADOOP_USERNAME@$ipaddr"; then
        echo "Failed to copy SSH key to $ipaddr"
    fi
done


for ipaddr in "${machines[@]}"; do
    # append to hosts file on the remote machines
    read -p "Press Enter to add hosts for $ipaddr"
    ssh -t "$HADOOP_USERNAME@$ipaddr" "echo '$hosts' | sudo tee -a /etc/hosts > /dev/null"
done


read -p "Press Enter to begin second process"
keyfile="/home/$HADOOP_USERNAME/.ssh/hadoop"

install_hadoop() {
    local ip="$1"

    # Execute install on the remote machine
    ssh -t "$HADOOP_USERNAME@$ip" '
        sudo apt-get update;
        sudo apt install -y openjdk-11-jdk;  # Using '-y' for non-interactive installation
        source exports.sh;
        bash -s < /tmp/install.sh;
        sudo mv hadoop '"$HADOOP_LOCATION"';
    '
}

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

    # install hadoop
    read -p "Press Enter to install hadoop for $ipaddr"
    # Copy the local script to the remote machine
    scp services/hadoop/local/install.sh "$HADOOP_USERNAME@$ipaddr:/tmp/"

    install_hadoop "$ipaddr" &
done

wait

#ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "bash -s" < "services/hadoop/master/setup.sh"
# Setup hadoop
read -p "Press Enter to setup config for master $HADOOP_MASTER_IP"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/config_setup.sh"

for ipaddr in "${machines[@]}"; do

    ssh -t "$HADOOP_USERNAME@$ipaddr" '
        sudo chown '"$HADOOP_USERNAME"':root -R '"$HADOOP_LOCATION"';
        sudo chmod g+rwx -R "'$HADOOP_LOCATION'"
    '

    #ssh "$HADOOP_USERNAME@$ipaddr" "sudo chown $HADOOP_USERNAME:root -R $HADOOP_LOCATION"
    #ssh "$HADOOP_USERNAME@$ipaddr" "sudo chmod g+rwx -R $HADOOP_LOCATION"
done

read -p "Press Enter to distribute configuration to ${machines[*]}"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/distribute_configuration.sh ${machines[*]}"
read -p "Press Enter to format hdfs"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/format.sh"
