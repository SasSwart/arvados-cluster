base:
  '*':
    - base
    - arvados.shell
  'salt_master':
    - postgres
    - nginx
    - nginx.passenger
    - arvados.repo
    - arvados.api
    - arvados.controller
  'arvados_workbench':
    - arvados.workbench
  'arvados_keepstore*':
    - arvados.keepstore
    - arvados.keepweb