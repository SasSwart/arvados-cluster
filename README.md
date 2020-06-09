## Getting Started

This repository supplements the one available [here](https://github.com/gijzelaerr/bio_cluster).
Follow the README in the above repository in order to provision VMs in the SURFsara HPC cloud.
Then use this repository to install the Arvados cluster using Salt.

### Salt Master
**Install Salt in an Ubuntu 18.04 environment** 

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