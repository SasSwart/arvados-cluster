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
  'workbench':
    - nginx
    - nginx.passenger
    - arvados.workbench
    - letsencrypt
  'keep*':
    - arvados.keepstore
    - arvados.keepweb
  'collections':
    - nginx
    - nginx.passenger
    - letsencrypt
    - arvados.keepweb
  'compute*':
    - docker
    - compute