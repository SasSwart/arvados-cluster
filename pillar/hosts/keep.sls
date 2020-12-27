---
{% set nginx_log = '/var/log/nginx' %}
{% import_yaml "../common/common.sls" as common -%}
{% set hostname = 'keep' %}

hostname: {{ hostname }}

letsencrypt:
  domainsets:
    www:
      - {{ hostname }}.{{ common.domain }}

nginx:
  server:
    config:
      {# STREAMS #}
      http:
        upstream keepproxy:
          - server: '127.0.0.1:25107'
  servers:
    managed:
      {# DEFAULT #}
      keepproxy_acme:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: {{ hostname }}.{{ common.domain }}
            - listen:
              - 80 default
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      keepproxy_tls:
        enabled: true
        config:
          - server:
            - server_name: {{ hostname }}.{{ common.domain }}
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            - location /:
              - proxy_pass: 'http://keepproxy'
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
            - access_log: {{ nginx_log }}/{{ common.domain }}.access.log combined
            - error_log: {{ nginx_log }}/{{ common.domain }}.error.log
            - client_max_body_size: 128m
