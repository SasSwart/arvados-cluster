base:
  '*':
    - base
    - arvados.repo
    - arvados.shell
  'salt_leader':
    - letsencrypt
    - postgres
    - nginx
    - nginx.passenger
    - arvados.api
    - arvados.controller
  'arvados_workbench':
    - nginx
    - nginx.passenger
    - arvados.workbench
    - letsencrypt
  'keep*':
    - arvados.keepstore
    - arvados.keepweb