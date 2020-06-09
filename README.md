# Build an Arvados Cluster using Salt

This repository supplements the one available [here](https://github.com/gijzelaerr/bio_cluster).
Follow the README in the said repository in order to provision VMs in the SURFsara HPC cloud.
Then use this repository to install the Arvados cluster using Salt.

# links

## the COVID-19 hackathon
 * https://github.com/virtual-biohackathons/covid-19-bh20

## The SURFsara HPC cloud
 * https://ui.hpccloud.surfsara.nl/
 * https://doc.hpccloud.surfsara.nl/

## arvados
 * https://arvados.org/
 * https://doc.arvados.org/v2.0/install/install-manual-prerequisites.html

## Getting Started

Read the top of init.py and follow the instructions

```
python3 -m venv env3
. env3/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -rrequirements.txt
python init.py
```

### Provisioning

#### main server
1 node
16+ GiB RAM
4+ cores
fast disk for database

#### SSO
1 node
2 GB ram
 
#### Workbench
1 node
8 GB ram
2+ cores
 
#### keepstore servers
2+ nodes
4 GiB RAM

#### compute worker nodes
0+ nodes
Depends on workload; scaled dynamically in the cloud

#### user shell nodes
0+
Depends on workload

### Configuring a Salt Master on Ubuntu 18.04
**Install Packages** 

Follow the instructions [here](https://repo.saltstack.com/#ubuntu)

Then:
```
apt-get update && apt-get install salt-api salt-cloud salt-master salt-minion salt-ssh salt-syndic
```

Packages in the above command listed [here](https://docs.saltstack.com/en/master/topics/installation/ubuntu.html).

**Configure the Salt Master**

Clone this repo into a directory of your choice on the master, and note that path as `<repo_path>` for use below.

The default configuration file is `/etc/salt/master`. Important changes below:
```
interface: <interface on which to listen, or 0.0.0.0>
file_roots:
  base:
    - '<repo_path>/include/*'
    - '<repo_path>/custom'
fileserver_backend:
  - roots
pillar_roots:
  base:
    - <repo_path>/pillar
```

The complete configuration reference is available [here](https://docs.saltstack.com/en/master/ref/configuration/master.html#configuration-salt-master)

**Enable the Salt master service**

> sudo systemctl enable --now salt-master

### DNS

Salt minions will automatically connect the whichever host the `salt` dns record resolves to.
Hence, add an A or CNAME record called `salt` to your DNS that resolves to your salt master host.

## Configuring a Salt minion on Ubuntu 18.04

### Install Packages
Follow the instructions [here](https://repo.saltstack.com/#ubuntu)

Then run:

```
apt-get update && apt-get install salt-minion
```

```
sudo systemctl enable --now salt-minion
```

The default configuration file should be sufficient.

## Minion to Master authentication

Each Salt minion will attempt to connect to whichever host is available at the `salt` dns record.
It will then send a public key to that master.

To allow the minion to be managed by the master, accept the minion's key on the master as follows:
```
salt-key -a <minion-id>
```

The `<minion-id>` should correspond to the hostname of the minion.

Keys, both accepted and unaccepted, can be listed by running `salt-key` without any arguments. Example output:

```
user@workstation:~$ sudo salt-key
Accepted Keys:
arvados
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```

Keys can be deleted by running:
```
salt-key -d <minion-id>
```

## Running Salt
```
salt <minion-id or '*'> state.apply
```