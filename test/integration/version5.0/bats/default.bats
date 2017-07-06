#!/usr/bin/env bats

@test "metricbeat script is in path" {
    command -v metricbeat.sh
}

@test "/tmp/metricbeat is in metricbeat.yml config" {
    grep "file: {filename: metricbeat, path: /tmp/metricbeat}" /etc/metricbeat/metricbeat.yml
}

@test "metricbeat is running" {
    service metricbeat status
}

@test "ca certificate does not exist" {
    [ ! -f /etc/metricbeat/ca.crt ]
}
