---
letsencrypt:
  {# # Install using packages instead of git #}
  use_package: true
  {# # A list of package/s to install. To find the correct name for the variant
  # you want to use, check https://certbot.eff.org/all-instructions
  # Usually, you'll need a single one, but you can also add other plugins here. #}
  pkgs:
    - python-certbot-nginx
  {# # Only used for the git install method (use_package: false) #}
  cli_install_dir: /opt/letsencrypt
  config: |
    server = https://acme-v02.api.letsencrypt.org/directory
    email = michael.crusoe@vu.nl 
    authenticator = webroot
    webroot-path = /var/www
    agree-tos = True
    renew-by-default = True
  config_dir:
    path: /etc/letsencrypt
    user: root
    group: root
    mode: 755
  domainsets:
    www:
      - workbench.covid19workflows-vu.surf-hosted.nl
  {# # The post_renew cmds are executed via renew_letsencrypt_cert.sh after every
  # run. For more fine grain control, consider placing scripts in the pre,
  # post, and/or deploy directories within /etc/letsencrypt/renewal-hooks/. For
  # more information, see: https://certbot.eff.org/docs/using.html#renewal #}
  post_renew:
    cmds:
      - service nginx reload
  cron:
    minute: 10
    hour: 2
    dayweek: 1