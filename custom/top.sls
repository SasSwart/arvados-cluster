base:
  '*':
    - base
    - arvados.repo
    - arvados.shell
  'salt_leader':
    - postgres
    - nginx
    - nginx.passenger
    - arvados.api
    - arvados.controller
  'arvados_workbench':
    - nginx
    - nginx.passenger
    - arvados.workbench
  'arvados_keepstore*':
    - arvados.keepstore
    - arvados.keepweb