---
{% import "./common.sls" as common -%}
{% set nginx_log = '/var/log/nginx' %}
{% set hostname = 'collections' %}

{# NGINX #}
nginx:
  {# SERVER #}
  server:
    config:
      {# STREAMS #}
      http:
        upstream collections_downloads_upstream:
          - server: '127.0.0.1:9002 fail_timeout=10s'

  servers:
    managed:
      {# DEFAULT #}
      arvados_collections_default:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: collections.{{ common.domain }} download.{{ common.domain }}
            - listen:
              - 80
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      {# COLLECTIONS / DOWNLOAD #}
      arvados_collections_downloads:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: collections.{{ common.domain }} download.{{ common.domain }}
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            - location /:
              - proxy_pass: 'http://collections_downloads_upstream'
              - proxy_read_timeout: 90
              - proxy_connect_timeout: 90
              - proxy_redirect: 'off'
              - proxy_set_header: X-Forwarded-Proto https
              - proxy_set_header: 'Host $http_host'
              - proxy_set_header: 'X-Real-IP $remote_addr'
              - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
              - proxy_buffering: 'off'
            - client_max_body_size: 0
            - proxy_http_version: '1.1'
            - proxy_request_buffering: 'off'
            - ssl_certificate: /etc/letsencrypt/live/collections.{{ common.domain }}/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/collections.{{ common.domain }}/privkey.pem
            - include: 'snippets/letsencrypt.conf'
            {# - include: 'snippets/snakeoil.conf' #}
            - access_log: {{ nginx_log }}/collections.{{ common.domain }}.access.log combined
            - error_log: {{ nginx_log }}/collections.{{ common.domain }}.error.log
