---
states:
  - postgres

{# POSTGRESQL #}
postgres:
  use_upstream_repo: false
  pkgs_extra:
    - postgresql-contrib
  postgresconf: |-
    listen_addresses = '*'  # listen on all interfaces
  acls:
    - ['local', 'all', 'postgres', 'peer']
    - ['local', 'all', 'all', 'peer']
    - ['host', 'all', 'all', '127.0.0.1/32', 'md5']
    - ['host', 'all', 'all', '::1/128', 'md5']
    - ['host', 'arvados_sso', 'arvados_sso', '127.0.0.1/32']
  users:
    arvados_sso:
      ensure: present
      password: changeme_arvados

  {# tablespaces:
     arvados_tablespace:
       directory: /path/to/some/tbspace/arvados_tbsp
       owner: arvados #}

  databases:
    arvados:
      owner: arvados_sso
      lc_ctype: 'en_US.UTF-8'
      lc_collate: 'en_US.UTF-8'
      template: 'template0'
      {# tablespace: arvados_tablespace #}
      schemas:
        public:
          owner: arvados_sso
