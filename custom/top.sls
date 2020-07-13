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
  'workbench':
    - nginx
    - nginx.passenger
    - arvados.workbench
    - letsencrypt
  'keep*':
    - arvados.keepstore
    - arvados.keepweb