us_locale:
  locale.present:
    - name: en_US.UTF-8

apt_https:
  pkg.installed:
  - pkgs:
    - gnupg
    - dirmngr
    - apt-transport-https
    - ca-certificates
    - ssl-cert

/var/www:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True