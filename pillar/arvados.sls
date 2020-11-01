{% import "./common.sls" as common -%}
{% set hostname = 'hackathon' %}

arvados:
  cluster:
    name: 'testc'
    domain: {{ common.domain }}

    database:
      name: arvados
      host: 127.0.0.1
      password: changeme_arvados
      user: arvados
      encoding: en_US.utf8
      client_encoding: UTF8

    tls:
      insecure: false

    tokens:
      system_root: x7Y25Dqe3qwGMZR6DJBTkgbo9iRnN5fK0Ktfdg1nBrEWICkI1S
      management: GwDPWFaNN7vWLpNksXgd1OinUFRtIXfGmh5ChhDDbkE55XuUOU
      rails_secret: zeBElZPOE9SgH8UBLATYPtEQR08REqwTzamC4OR8PqXhnHWD4G
      anonymous_user: oZORRzsQP2RXEY6oJo7rEWVmD0Tf2hvUoZDOvrzzrZy23uzoT0
      provider_secret: WWFUk2yOOoX4J7D7ZkbaITa9TLzavA6JuwEz93QUvcoBlZjNhG

    Volumes:
      ### VOLUME_ONE
      testc-nyw5e-000000000000001:
        Driver: Directory
        DriverParameters: {Root: /tmp/volume}
        AccessViaHosts: {'http://keep0.covid19workflows-vu.surf-hosted.nl:25107': {}}
        Replication: 1
      ### VOLUME_TWO
      testc-nyw5e-000000000000002:
        Driver: Directory
        DriverParameters: {Root: /tmp/volume}
        AccessViaHosts: {'http://keep1.covid19workflows-vu.surf-hosted.nl:25107': {}}
        Replication: 1

    secrets:
      blob_signing_key: ZlA9P6apFvmHgyUNc9sfNpqGL4sAx4Kr0mFRDBpUoBkyNc0kP0
      workbench_secret_key: j8LYkESP8seSsDaPbgR40zTX1WsbmrNandZwdScqrTOAkrChs0
      dispatcher_access_key: 5LYOKn7SAsUvpi7bOSBIxvb8ftQffjZSl8SoJpiOuXRMZ5W8qE
      dispatcher_secret_key: XxqQ8wT9oIBKnRVHeBJPcQCksFz5XvriUNXvTYH0d1KU6hZg83
      keep_access_key: lgGnWaUSCjMrGfHBNdCYUF1HuqSNs0jj4BQRivSrVSwPGuklLj
      keep_secret_key: E1LxekzbhVghiJbhHxxdof2cnmYpz59VvY2awSjd106uHMTZxl
    
    Users:
      NewUsersAreActive: true
      AutoAdminFirstUser: true
      AutoSetupNewUsers: true
      AutoSetupNewUsersWithRepository: False
    
    Services:
      Workbench1:
        ExternalURL: "https://workbench.covid19workflows-vu.surf-hosted.nl"
      Keepstore:
        InternalURLs:
          "http://keep0.covid19workflows-vu.surf-hosted.nl:25107": {}
          "http://keep1.covid19workflows-vu.surf-hosted.nl:25107": {}
      Controller:
        ExternalURL: "https://hackathon.covid19workflows-vu.surf-hosted.nl"
        InternalURLs:
          "http://localhost:8003": {}
      RailsAPI:
        InternalURLs:
          "http://localhost:8004": {}
      SSO:
        ExternalURL: "https://sso.covid19workflows-vu.surf-hosted.nl"
      WebDAV:
        ExternalURL: https://collections.covid19workflows-vu.surf-hosted.nl
        InternalURLs:
          "http://localhost:9002": {}
      Websocket:
        ExternalURL: wss://ws.covid19workflows-vu.surf-hosted.nl/websocket
        InternalURLs:
          "http://localhost:8005": {}
  api:
    pkg:
      name: arvados-api-server
    gem:
      name:
        - arvados-cli
    service:
      name: nginx
      port: 8004
  controller:
    hostname: hackathon
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
  keepweb:
    pkg:
      name: keep-web
    service:
      name: keep-web
      port: 9002
  webdav:
    collections:
      hostname: 'collections'
  keepstore:
    pkg:
      name: keepstore
    service:
      name: keepstore
      port: 25107
    hosts:
      - keep0
      - keep1
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
    hostname: workbench
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
