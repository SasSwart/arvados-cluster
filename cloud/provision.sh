#!/bin/bash

USER="ubuntu"
MASTER="salt_leader"
PRIVATE_KEY="/root/id_rsa"
REPO="https://github.com/SasSwart/arvados-cluster.git"

# Provision hosts
salt-cloud -y -m /root/cloud/map -P

# Open Salt required firewall ports on all provisioned hosts
nodes=$(salt-cloud -f list_nodes surfsara --out=json)
echo $nodes | jq '.surfsara.opennebula[].private_ips[0]' | sed 's/\"//g' > /root/hosts
parallel-ssh -O "UserKnownHostsFile=/dev/null" -O "StrictHostKeyChecking=no" -o /root/output -e /root/error -h /root/hosts -l $USER -x "-i $PRIVATE_KEY" sudo ufw allow 4505
parallel-ssh -O "UserKnownHostsFile=/dev/null" -O "StrictHostKeyChecking=no" -o /root/output -e /root/error -h /root/hosts -l $USER -x "-i $PRIVATE_KEY" sudo ufw allow 4506

# Deploy Salt Code to master node
master_ip=$(echo $nodes | jq ".surfsara.opennebula.$MASTER.private_ips[0]" | sed 's/\"//g')
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "sudo salt $MASTER pkg.install git"
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "git clone --recursive $REPO ~/arvados"
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "cd ~/arvados && git pull && git submodule update --init"
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "sudo cp ~/arvados/cloud/roots.conf /etc/salt/master.d/roots.conf"
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "sudo systemctl restart salt-master.service"

# Apply state to master
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "sudo salt 'salt_leader' state.apply"

# Apply state to all
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip "sudo salt '*' state.apply"