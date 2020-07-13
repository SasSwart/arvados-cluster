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

/etc/arvados:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/var/www:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/ferm/ferm.conf:
  file.managed:
    - source: salt://base/ferm.conf
    - user: root
    - group: root
    - mode: 644

/etc/ferm/conf.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

ferm:
  pkg:
  - installed
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: ferm
      - file: /etc/ferm/ferm.conf