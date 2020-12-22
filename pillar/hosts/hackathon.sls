---
{% import_yaml "../common/common.sls" as common -%}
{% set hostname = 'hackathon' %}
{% set nginx_log = '/var/log/nginx' %}

hostname: {{ hostname }}
domain: {{ common.domain }}

slurm:
  lookup:
    control_machine: "hackathon"

letsencrypt:
  domainsets:
    www:
      - {{ hostname }}.{{ common.domain }}

arvados:
  config:
    group: www-data

nginx:
  server:
    config:
      {# STREAMS #}
      http:
        'geo $external_client':
          default: 1
          '127.0.0.0/24': 0
          '145.100.59.86/22': 0
          '156.155.176.38/24': 0
        upstream controller_upstream:
          - server: 'localhost:8003  fail_timeout=10s'
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

      arvados_controller_default:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: {{ hostname }}.{{ common.domain }} api.{{ hostname }}.{{ common.domain }}
            - listen:
              - 80 default
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      arvados_controller:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: {{ hostname }}.{{ common.domain }}
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            - location /:
              - proxy_pass: 'http://controller_upstream'
              - proxy_read_timeout: 300
              - proxy_connect_timeout: 90
              - proxy_redirect: 'off'
              - proxy_set_header: X-Forwarded-Proto https
              - proxy_set_header: 'Host $http_host'
              - proxy_set_header: 'X-Real-IP $remote_addr'
              - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
              - proxy_set_header: 'X-External-Client $external_client'
            - ssl_certificate: /etc/letsencrypt/live/{{ hostname }}.{{ common.domain }}/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/{{ hostname }}.{{ common.domain }}/privkey.pem
            - include: 'snippets/letsencrypt.conf'
            {# - include: 'snippets/snakeoil.conf' #}
            - access_log: {{ nginx_log }}/{{ common.domain }}.access.log combined
            - error_log: {{ nginx_log }}/{{ common.domain }}.error.log
            - client_max_body_size: 128m
