# Build an Arvados Cluster using Salt

## links

### the COVID-19 hackathon

 * https://github.com/virtual-biohackathons/covid-19-bh20

### The SURFsara HPC cloud

 * https://ui.hpccloud.surfsara.nl/
 * https://doc.hpccloud.surfsara.nl/

### arvados

 * https://arvados.org/
 * https://doc.arvados.org/v2.0/install/install-manual-prerequisites.html

## Provisioning
Set your SURFsara username and password in cloud/surfsara.conf

Run:
```
docker-compose run salt-cloud
```
## Specs
See `cloud/map`
### main server
fast disk for database

### compute worker nodes
0+ nodes
Depends on workload; scaled dynamically in the cloud

### user shell nodes
0+
Depends on workload

### Configuring a Salt Master on Ubuntu 18.04
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