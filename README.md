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

To build an Arvados cluster, run:
```
docker-compose run provision
```

To destroy an Arvados cluster, run:
```
docker-compose run destroy
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