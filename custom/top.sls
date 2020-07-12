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
  'workbench.hackathon':
    - nginx
    - nginx.passenger
    - arvados.workbench
    - letsencrypt
  'keep*.hackathon':
    - arvados.keepstore
    - arvados.keepweb