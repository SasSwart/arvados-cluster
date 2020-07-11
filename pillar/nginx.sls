---
states:
  - nginx.passenger

{% set nginx_log = '/var/log/nginx' %}

nginx:
  install_from_phusionpassenger: true

  lookup:
    passenger_package: libnginx-mod-http-passenger
    passenger_config_file: /etc/nginx/conf.d/mod-http-passenger.conf

  server:
    config:
      include: 'modules-enabled/*.conf'
      worker_processes: 4

  servers:
    managed:
      {# Remove default webserver #}
      default:
        enabled: false
  snippets:
    letsencrypt.conf:
      - location ^~ /.well-known/acme-challenge/:
          - proxy_pass: http://localhost:9999