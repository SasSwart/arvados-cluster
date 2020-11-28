# Build an Arvados Cluster using Salt

Welcome!
Would you like to [use](##User) or [contribute](##Contributor) to this project?
Note: We recommend that contributors read the [user](##User) section for context before reading the [contributor](##Contributor) section.

## User
### Setup
To use this project to provision an Arvados cluser, you will need to clone it to your workstation.
You will also need Docker Compose.

There are two parts to this project.
A provisioning mechanism and a configuration management system.

### Provisioning
This project uses [salt-cloud](https://docs.saltstack.com/en/latest/topics/cloud/) to provision the infrastructure required by an Arvados Cluster.
To encapsulate the technicalities of salt-cloud from your workstation, we have wrapped them in Docker containers that can be run using Docker Compose for convenience.

Before you can use this facility, you will need to configure your cloud [provider](./cloud/providers). Salt-cloud supports a variety of cloud providers natively, for which you should only need to add a config file to the directory linked previously.

Example:
* Provision a brand new cluster: `docker-compose run provision`
* To destroy an Arvados cluster: `docker-compose run destroy`

When provisioning a new cluster, the provisioning system will preinstall Salt minions to all of the virtual machines configured, configure the salt "master" (we will use the term orchestrator from now on). It will also accept the salt-keys of all the minions. It will then run salt once to configure the entire cluster.

Should nothing go awry, you should have a functioning cluster after running the above command.
Because this project is a work in progress, expect things to go awry.

## Contributor
### Setup
This project depends on the repositories shown in the `gitfs_remotes` section of the [roots.conf](./custom/salt-leader/roots.conf) file.
Feel free to clone those and glance over them to become familiar with the structure of the project.

How these dependencies fit together is described in the [formula's top file](./custom/top.sls) and the [pillar top file](./pillar/top.sls).

The structure of the provisioned infrastructure is described in the salt-cloud [map file](./cloud/map)

## links

### the COVID-19 hackathon

 * https://github.com/virtual-biohackathons/covid-19-bh20

### The SURFsara HPC cloud

 * https://ui.hpccloud.surfsara.nl/
 * https://doc.hpccloud.surfsara.nl/

### arvados

 * https://arvados.org/
 * https://doc.arvados.org/v2.0/install/install-manual-prerequisites.html

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