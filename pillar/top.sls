base:
  '*':
    - letsencrypt
  'hackathon':
    - postgresql
    - nginx
    - arvados
    - nginx_arvados_api
    - nginx_arvados_controller
    - letsencrypt_controller
  'workbench':
    - nginx
    - nginx_workbench
    - arvados
    - letsencrypt_workbench
  'ws':
    - nginx
    - arvados
    - letsencrypt_ws
  'keep*':
    - arvados