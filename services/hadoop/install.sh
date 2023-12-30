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
echo "########## Adding Hadoop User to each machine ##########"

for ipaddr in "${machines[@]}"; do
    # add the exports.sh file to the remote machine
    scp exports.sh "$BASE_USER@$ipaddr:exports.sh"

    # Add the hadoop user
    ssh "$BASE_USER@$ipaddr" "source exports.sh; bash -s" < "services/hadoop/local/add_user.sh"
    scp exports.sh "$HADOOP_USERNAME@$ipaddr:exports.sh"

    echo "Added hadoop user to $ipaddr"
done

echo "########## Finished adding hadoop users ##########"

echo "########## Setting up passwordless ssh login to hadoop user ##########"
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
echo "########## Finished setting up passwordless ssh login to hadoop user ##########"

echo "########## Beginning Hadoop Install ##########"
keyfile="/home/$HADOOP_USERNAME/.ssh/hadoop"
for ipaddr in "${machines[@]}"; do
    echo "Sharing keys for $ipaddr..."
    # share public keys with all other machines on the cluster
    # send key to all other ips
    ssh "$BASE_USER@$ipaddr" "source exports.sh; sudo -u $HADOOP_USERNAME ssh-keygen -t rsa -f $keyfile -N ''; sudo chmod 600 $keyfile"
    for ip in "${machines[@]}"; do

        config="Host $ip
            HostName $ip
            IdentityFile $keyfile"

        ssh -t $HADOOP_USERNAME@$ipaddr "ssh-copy-id -i $keyfile.pub $HADOOP_USERNAME@$ip;"
        ssh -t $HADOOP_USERNAME@$ipaddr "echo '$config' >> /home/$HADOOP_USERNAME/.ssh/config"
    done
done

# install hadoop
echo "installing hadoop for master $HADOOP_MASTER_IP..."
scp services/hadoop/local/install.sh "$HADOOP_USERNAME@$HADOOP_MASTER_IP:/tmp/"
ssh -t "$HADOOP_USERNAME@$HADOOP_MASTER_IP" '
        sudo apt-get update;
        sudo apt install -y openjdk-11-jdk;
        source exports.sh;
        bash -s < /tmp/install.sh;
        sudo mv hadoop '"$HADOOP_LOCATION"';
    '

echo "Sending $HADOOP_VERSION.tar.gz to other machines"
for ipaddr in "${machines[@]}"; do
    if [[ "$ipaddr" != "$HADOOP_MASTER_IP" ]]; then
        echo "sending to $ipaddr..."
        ssh -t "$HADOOP_USERNAME@$HADOOP_MASTER_IP" 'scp -i ~/.ssh/hadoop '"$HADOOP_VERSION"'.tar.gz "'"$HADOOP_USERNAME"'@'"$ipaddr"':/home/'"$HADOOP_USERNAME"';"'

        echo "expanding hadoop on $ipaddr..."
        ssh -t "$HADOOP_USERNAME@$ipaddr" '
            sudo apt-get update;
            sudo apt install -y openjdk-11-jdk;
            source exports.sh;
            tar xzf '"$HADOOP_VERSION"'.tar.gz;
            mv '"$HADOOP_VERSION"' hadoop;
            sudo mv hadoop '"$HADOOP_LOCATION"'
        '
    fi
done

echo "########## Finished Hadoop Install ##########"

# Setup hadoop
echo "########## Starting Hadoop Setup ##########"
echo "Setting up config for master $HADOOP_MASTER_IP..."
scp services/hadoop/master/setup/config_setup.sh "$HADOOP_USERNAME@$HADOOP_MASTER_IP:/tmp/"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; chmod +x /tmp/config_setup.sh; /tmp/config_setup.sh $HADOOP_MASTER_IP ${machines[@]}"

read -p "Press Enter to distribute configuration to ${machines[*]}"

#scp services/hadoop/master/setup/distribute_configuration.sh "$HADOOP_USERNAME@$HADOOP_MASTER_IP:/tmp/"
for node in "${machines[@]}"; do
    ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; scp -r -i ~/.ssh/hadoop $HADOOP_LOCATION/etc/hadoop/* $node:$HADOOP_LOCATION/etc/hadoop/"
done

read -p Press Enter to set hadoop permissions
for ipaddr in "${machines[@]}"; do
    ssh -t "$HADOOP_USERNAME@$ipaddr" '
        sudo chown '"$HADOOP_USERNAME"':root -R '"$HADOOP_LOCATION"';
        sudo chmod g+rwx -R "'$HADOOP_LOCATION'"
    '
done

echo "########## Finished Hadoop Setup ##########"

read -p "Press Enter to format hdfs"
ssh "$HADOOP_USERNAME@$HADOOP_MASTER_IP" "source exports.sh; bash -s" < "services/hadoop/master/setup/format.sh"
