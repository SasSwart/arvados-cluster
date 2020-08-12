base:
  '*':
    - letsencrypt
  'hackathon':
    - postgresql
    - nginx
    - arvados
    - google_oauth
    - nginx_arvados_api
    - nginx_arvados_controller
    - letsencrypt_controller
  'workbench':
    - nginx
    - nginx_workbench
    - arvados
    - google_oauth
    - letsencrypt_workbench
  'collections':
    - nginx
    - nginx_keepweb
    - arvados
    - letsencrypt_keepweb
  'keep*':
    - arvados