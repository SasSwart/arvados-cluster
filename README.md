# Build an Arvados Cluster using Salt

This repository supplements the one available [here](https://github.com/gijzelaerr/bio_cluster).
Follow the README in the said repository in order to provision VMs in the SURFsara HPC cloud.
Then use this repository to install the Arvados cluster using Salt.

## Getting Started

### Configuring a Salt Master on Ubuntu 18.04
**Install Packages** 

Follow the instructions [here](https://repo.saltstack.com/#ubuntu)

Then:
> apt-get update && apt-get install salt-api salt-cloud salt-master salt-minion salt-ssh salt-syndic

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

```apt-get update && apt-get install salt-minion```

```sudo systemctl enable --now salt-minion```

The default configuration file should be sufficient.

## Minion to Master authentication

Each Salt minion will attempt to connect to whichever host is available at the `salt` dns record.
It will then send a public key to that master.

To allow the minion to be managed by the master, accept the minion's key on the master as follows:
`salt-key -a <minion-id>`

The `<minion-id>` should correspond to the hostname of the minion.

Keys, both accepted and unaccepted, can be listed by running `salt-key` without any arguments

Keys can be deleted by running:
```salt-key -d <minion-id>```