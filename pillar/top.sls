base:
  'salt_master':
    - postgresql
    - nginx
    - arvados
    - nginx_arvados_api
    - nginx_arvados_controller
  'arvados_sso':
  'arvados_workbench':
    - nginx_workbench
  'arvados_keepstore*':
