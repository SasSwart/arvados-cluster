---
{% import "./common.sls" as common -%}
{% set nginx_log = '/var/log/nginx' %}

arvados:
  config:
    group: www-data

nginx:
  servers:
    managed:
      arvados_api:
        enabled: true
        overwrite: true
        config:
          - server:
            - listen: '127.0.0.1:8004'
            - server_name: localhost-api
            - root: /var/www/arvados-api/current/public
            - index:  index.html index.htm
            - access_log: {{ nginx_log }}/api.{{ common.domain }}-upstream.access.log combined
            - error_log: {{ nginx_log }}/api.{{ common.domain }}-upstream.error.log
            - passenger_enabled: 'on'
            - client_max_body_size: 128m
