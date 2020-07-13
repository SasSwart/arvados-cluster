---
{% set nginx_log = '/var/log/nginx' %}
{% set domain = 'covid19workflows-vu.surf-hosted.nl' %}
{% set hostname = 'hackathon' %}

{# NGINX #}
nginx:
  {# SERVER #}
  server:
    config:

      {# STREAMS #}
      http:
        'geo $external_client':
          default: 1
          '127.0.0.0/24': 0
        upstream controller_upstream:
          - server: 'localhost:8003  fail_timeout=10s'

  {# SITES #}
  servers:
    managed:
      {# DEFAULT #}
      arvados_controller_default:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: {{ hostname }}.{{ domain }} api.{{ hostname }}.{{ domain }}
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
            - server_name: {{ hostname }}.{{ domain }}
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
            - ssl_certificate: /etc/letsencrypt/live/hackathon.covid19workflows-vu.surf-hosted.nl/fullchain.pem
            - ssl_certificate_key: /etc/letsencrypt/live/hackathon.covid19workflows-vu.surf-hosted.nl/privkey.pem
            - include: 'snippets/letsencrypt.conf'
            {# - include: 'snippets/snakeoil.conf' #}
            - access_log: {{ nginx_log }}/example.net.access.log combined
            - error_log: {{ nginx_log }}/example.net.error.log
            - client_max_body_size: 128m
