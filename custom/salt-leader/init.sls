/etc/salt/master.d/roots.conf:
  file.managed:
    - source: salt://salt-leader/roots.conf
    - user: root
    - group: root
    - mode: 644