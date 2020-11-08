apt_compute:
  pkg.installed:
  - pkgs:
    - python-arvados-fuse 
    - crunch-dispatch-slurm
    - slurm
    - slurmd
    - slurmctld
    - slurm-client
    - crunch-run 
    - arvados-docker-cleaner
    - docker-ce 
    - docker-ce-cli 
    - containerd.io

/etc/slurm-llnl/slurm.conf:
  file.managed:
    - source: salt://compute/slurm.conf
    - user: root
    - group: root
    - mode: 644

/etc/slurm-llnl/cgroup.conf:
  file.managed:
    - source: salt://compute/cgroup.conf
    - user: root
    - group: root
    - mode: 644

/etc/fuse.conf:
  file.managed:
    - source: salt://compute/fuse.conf
    - user: root
    - group: root
    - mode: 644