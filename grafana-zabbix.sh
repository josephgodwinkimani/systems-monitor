#!/usr/bin/env bash

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e
log_info() {
  printf "\n\e[0;35m $1\e[0m\n\n"
}

log_info "Install Zabbix plugin for Grafana dashboard ..."
grafana-cli plugins list-remote
grafana-cli plugins install alexanderzobnin-zabbix-app
systemctl restart grafana-server
echo "To configure go to https://alexanderzobnin.github.io/grafana-zabbix/configuration/"
