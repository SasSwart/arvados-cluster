#!/bin/bash

USER="ubuntu"
MASTER="hackathon"
PRIVATE_KEY="/root/id_rsa"
REPO="https://github.com/SasSwart/arvados-cluster.git"

# Provision hosts
salt-cloud -y -m /root/cloud/map -P

# Open Salt required firewall ports on all provisioned hosts
nodes=$(salt-cloud -f list_nodes surfsara --out=json)
echo $nodes | jq '.surfsara.opennebula[].private_ips[0]' | sed 's/\"//g' > /root/hosts
parallel-ssh -O "UserKnownHostsFile=/dev/null" -O "StrictHostKeyChecking=no" -o /root/output -e /root/error -h /root/hosts -l $USER -x "-i $PRIVATE_KEY" sudo ufw allow 4505
parallel-ssh -O "UserKnownHostsFile=/dev/null" -O "StrictHostKeyChecking=no" -o /root/output -e /root/error -h /root/hosts -l $USER -x "-i $PRIVATE_KEY" sudo ufw allow 4506

bootstrap_ssh(){
  ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $PRIVATE_KEY $USER@$master_ip $1
}

# Deploy Salt Code to master node
master_ip=$(echo $nodes | jq ".surfsara.opennebula.$MASTER.private_ips[0]" | sed 's/\"//g')
bootstrap_ssh "sudo salt $MASTER pkg.install git"
bootstrap_ssh "sudo salt $MASTER pkg.install git-crypt"
bootstrap_ssh "git clone --recursive $REPO ~/arvados"
bootstrap_ssh "cd ~/arvados && git pull && git submodule update --init && git-crypt init"
bootstrap_ssh "sudo cp ~/arvados/cloud/roots.conf /etc/salt/master.d/roots.conf"
bootstrap_ssh "sudo systemctl restart salt-master.service"

# Apply state to master
bootstrap_ssh "sudo salt '$MASTER' state.apply"

# Accept Salt keys
bootstrap_ssh "sudo salt-key -A -y"

# Apply state to all
bootstrap_ssh "sudo salt '*' state.apply"