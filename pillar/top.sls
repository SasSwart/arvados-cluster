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
  'collections':
    - nginx
    - nginx_keepweb
    - letsencrypt_keepweb
  'keep*':
    - arvados