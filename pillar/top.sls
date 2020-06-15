base:
  'salt_master':
    - postgresql
    - nginx
    - arvados
    - nginx_arvados_api
    - nginx_arvados_controller
  'arvados_workbench':
    - nginx
    - nginx_workbench
    - arvados