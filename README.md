ansible-nginx
=========

This role installs and sets up Metricbeat package on Ubuntu.

Requirements
------------

This role requires Ansible 2.2 or higher. It has been tested on Ubuntu Xenial

Role Variables
--------------

A list of role variables with their descriptions is below

```yaml

# The version of metricbeat to install
metricbeat_version: 5.3

# `metricbeat_config` is templated directly into metricbeat.yml for the config.
# You are expected to override this variable, as these configurations are
# only suited for development purposes.
# See https://github.com/elastic/metricbeat/blob/master/etc/metricbeat.yml for
# an exhaustive list of configurations.
metricbeat_config:
  fields:
    env: "{{ env | default('dev') }}"
  metricbeat.modules:
  - module: system
    metricsets:
      - cpu
      - load
      - core
      - diskio
      - filesystem
      - fsstat
      - memory
      - network
      - process
      - socket
    enabled: true
    period: 60s
    processes: ['.*']
  - module: nginx
    metricsets: ["stubstatus"]
    enabled: true
    period: 60s
    hosts: ["http://127.0.0.1"]
  - module: redis
    metricsets: ["info", "keyspace"]
    enabled: true
    period: 60s
    hosts: ["127.0.0.1:6379"]
    timeout: 1s
    network: tcp
    maxconn: 1
  output.elasticsearch:
    enabled: true
    hosts: ["{{ elasticsearch_proxy_url }}"]
    username: "{{ es_filebeat_user }}"
    password: "{{ es_filebeat_password }}"
    index: "metricbeat-{{env}}-%{+yyyy.MM.dd}"
  logging:
    to_syslog: false
    to_files: true
    level: error
    files:
      - path: /var/log/metricbeat
      - name: metricbeat.log
      - keepfiles: 5
      - rotateeverybytes: 10485760 # = 10MB

```

Dependencies
------------

None

Example Playbook
----------------
- Install nginx with a custom site template

```
  hosts:
   - servers

  roles:
    - metricbeat

  vars:
    - elasticsearch_proxy_url: "https://my-elasticsearch-proxy.foo.com"

```

License
-------

BSD

Author Information
------------------

Fynd
