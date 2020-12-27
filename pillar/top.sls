base:
  '*':
    - common/common
    - common/arvados
    - common/letsencrypt
    - google_oauth
  'hackathon':
    - postgresql
    - nginx
    - hosts/hackathon
  'workbench':
    - nginx
    - hosts/workbench
  'collections':
    - nginx
    - nginx_keepweb
    - letsencrypt_keepweb
  'keep':
    - hosts/keep
    - nginx
  'keep0':
    - hosts/keep0
  'keep1':
    - hosts/keep1
  'compute0':
    - hosts/compute0
  'compute1':
    - hosts/compute1
  'compute2':
    - hosts/compute2
  'compute3':
    - hosts/compute3