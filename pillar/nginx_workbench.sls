---
{% import "./common.sls" as common -%}
{% set nginx_log = '/var/log/nginx' %}
{% set hostname = 'workbench' %}

arvados:
  config:
    group: www-data

nginx:
  server:
    config:
      http:
        upstream workbench_upstream:
          - server: '127.0.0.1:9000 fail_timeout=10s'

  servers:
    managed:
      arvados_workbench_default:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: "{{ hostname }}.{{ common.domain }}"
            - listen:
              - 80
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      arvados_workbench:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: {{ common.domain }}
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            - location /:
              - proxy_pass: 'http://workbench_upstream'
              - proxy_read_timeout: 300
              - proxy_connect_timeout: 90
              - proxy_redirect: 'off'
              - proxy_set_header: X-Forwarded-Proto https
              - proxy_set_header: 'Host $http_host'
              - proxy_set_header: 'X-Real-IP $remote_addr'
              - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
            - ssl_certificate: /etc/letsencrypt/live/workbench.{{ common.domain}}/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/workbench.{{ common.domain}}/privkey.pem
            - include: 'snippets/letsencrypt.conf'
            {# - include: 'snippets/snakeoil.conf' #}
            - access_log: {{ nginx_log }}/{{ common.domain }}.access.log combined
            - error_log: {{ nginx_log }}/{{ common.domain }}.error.log

      arvados_workbench_upstream:
        enabled: true
        overwrite: true
        config:
          - server:
            - listen: '127.0.0.1:9000'
            - server_name: {{ common.domain }}
            - root: /var/www/arvados-workbench/current/public
            - index:  index.html index.htm
            - access_log: {{ nginx_log }}/{{ common.domain }}-upstream.access.log combined
            - error_log: {{ nginx_log }}/{{ common.domain }}-upstream.error.log
            - passenger_enabled: 'on'
            - passenger_user: 'www-data'
            - client_max_body_size: 128m
