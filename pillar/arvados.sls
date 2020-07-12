{% set domain = 'covid19workflows-vu.surf-hosted.nl' %}
{% set hostname = 'hackathon' %}

arvados:
  cluster:
    name: {{ hostname }}
    domain: {{ domain }}

    database:
      name: arvados
      host: 127.0.0.1
      password: changeme_arvados
      user: arvados
      encoding: en_US.utf8
      client_encoding: UTF8

    tls:
      insecure: true

    tokens:
      system_root: changeme_system_root_token
      management: changeme_management_token
      rails_secret: changeme_rails_secret_token
      anonymous_user: changeme_anonymous_user_token
      provider_secret: changeme_provider_secret_token

    volumes:
      volume_one:
        cluster: {{ hostname }}
        volume_id: '000000000000000'
        access_via_hosts:
          "http://keep0.{{domain}}:25107/": {}
          "http://keep1.{{domain}}:25107/": {}
        replication: 2
        driver: Directory
        driver_parameters:
          Root: /tmp

    secrets:
      blob_signing_key: changeme_blob_signing_key
      workbench_secret_key: changeme_workbench_secret_key
      dispatcher_access_key: changeme_dispatcher_access_key
      dispatcher_secret_key: changeme_dispatcher_secret_key
      keep_access_key: changeme_keep_access_key
      keep_secret_key: changeme_keep_secret_key

    api:
      pkg:
        name:
          - arvados-api-server
          - arvados-dispatch-cloud
      gem:
        name:
          - arvados-cli
      service:
        name:
          - nginx
        port: 8004
    controller:
      pkg:
        name: arvados-controller
      service:
        name: arvados-controller
        port: 8003
    dispatcher:
      pkg:
        name:
          - crunch-dispatch-local
      service:
        name: crunch-dispatch-local
        port: 9006
    keepproxy:
      pkg:
        name: keepproxy
      service:
        name: keepproxy
        port: 25107
    keepweb:
      pkg:
        name: keep-web
      service:
        name: keep-web
        port: 9002
    keepstore:
      pkg:
        name: keepstore
      service:
        name: keepstore
        port: 25107
    githttpd:
      pkg:
        name: arvados-git-httpd
      service:
        name: arvados-git-httpd
        port: 9001
    shell:
      pkg:
        name:
          - arvados-client
          - arvados-src
          - libpam-arvados
          - python-arvados-fuse
          - python-arvados-python-client
          - python3-arvados-cwl-runner
      gem:
        name:
          - arvados-cli
          - arvados-login-sync
    workbench:
      pkg:
        name: arvados-workbench
      service:
        name: nginx
    websocket:
      pkg:
        name: arvados-ws
      service:
        name: arvados-ws
        port: 8005
    sso:
      pkg:
        name: arvados-sso
      service:
        name: arvados-sso
        port: 8900
