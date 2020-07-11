base:
  'salt_leader':
    - postgresql
    - nginx
    - arvados
    - nginx_arvados_api
    - nginx_arvados_controller
    - letsencrypt_controller
  'arvados_workbench1':
    - nginx
    - nginx_workbench
    - arvados
    - letsencrypt_workbench
  'arvados_keep*':
    - arvados