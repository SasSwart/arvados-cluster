base:
  '*':
    - letsencrypt
    - google_oauth
    - common
  'hackathon':
    - postgresql
    - nginx
    - arvados
    - nginx_arvados_api
    - nginx_arvados_controller
    - letsencrypt_controller
    - hosts/hackathon
  'workbench':
    - nginx
    - nginx_workbench
    - arvados
    - letsencrypt_workbench
    - hosts/workbench
  'collections':
    - nginx
    - nginx_keepweb
    - arvados
    - letsencrypt_keepweb
  'keep*':
    - arvados
  'keep0':
    - hosts/keep0
  'keep1':
    - hosts/keep1