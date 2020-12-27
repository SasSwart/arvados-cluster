base:
  '*':
    - base
    - arvados.repo
    - arvados.shell
  'hackathon':
    - docker
    - salt-leader
    - compute
    - letsencrypt
    - postgres
    - nginx
    - nginx.passenger
    - arvados.api
    - arvados.controller
    - arvados.websocket
    - slurm
    - slurm.server
    - slurm.node
  'workbench':
    - letsencrypt
    - nginx
    - nginx.passenger
    - arvados.workbench
  'keep':
    - letsencrypt
    - nginx
    - arvados.keepproxy
  'keep*':
    - arvados.keepstore
    - arvados.keepweb # TODO: Do we need this on the store hosts?
  'collections':
    - nginx
    - nginx.passenger
    - letsencrypt
    - arvados.keepweb
  'compute*':
    - docker
    - slurm
    - slurm.node
    - compute
