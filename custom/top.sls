base:
  '*':
    - base
    - arvados.repo
    - arvados.shell
  'hackathon':
    - letsencrypt
    - postgres
    - nginx
    - nginx.passenger
    - arvados.api
    - arvados.controller
  'wss':
    - letsencrypt
    - postgres
    - nginx
    - nginx.passenger
    - arvados.websocket
  'workbench':
    - nginx
    - nginx.passenger
    - arvados.workbench
    - letsencrypt
  'keep0':
    - arvados.keepstore
    - arvados.keepweb
  'keep1':
    - arvados.keepstore
    - arvados.keepweb
  'keep':
    - arvados.keepproxy