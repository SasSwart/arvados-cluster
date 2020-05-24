arvados:
  cluster:
    name: test_cluster
    domain: host-s.net

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
        # the volume name will be composed with
        # <cluster>-nyw5e-<volume>
        cluster: fixme
        volume_id: '000000000000000'
        access_via_hosts:
          "http://keep0.host-s.net:25107/": {}
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
