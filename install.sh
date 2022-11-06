#!/bin/bash
# unattended installation - run baby run
# creating Prometheus System Users and Directory (node_exporter and prometheus)
sudo useradd --no-create-home --shell /bin/false prometheus && useradd --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
#
# download prometheus
cd /opt/ && wget https://github.com/prometheus/prometheus/releases/download/v2.37.2/prometheus-2.37.2.linux-amd64.tar.gz
tar -xf prometheus-2.37.2.linux-amd64.tar.gz
cd prometheus-2.37.2.linux-amd64
sudo cp /opt/prometheus-2.37.2.linux-amd64/prometheus /usr/local/bin
sudo cp /opt/prometheus-2.37.2.linux-amd64/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
#
# copy Prometheus Console Libraries
sudo cp -r /opt/prometheus-2.37.2.linux-amd64/consoles /etc/prometheus
sudo cp -r /opt/prometheus-2.37.2.linux-amd64/console_libraries /etc/prometheus
sudo cp -r /opt/prometheus-2.37.2.linux-amd64/prometheus.yml /etc/prometheus
#
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
# confirm installation
sudo cat /etc/prometheus/prometheus.yml
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus 
#
# install node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar -xf node_exporter-1.4.0.linux-amd64.tar.gz
sudo mv node_exporter-1.4.0.linux-amd64/node_exporter /usr/local/bin
sudo rm -r node_exporter-1.4.0.linux-amd64*
sudo tee /etc/systemd/system/node_exporter.service <<"EOF"
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
Group=node_exporter
EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
EOF
#
# restart service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
#
# install grafana
wget -q -O /usr/share/keyrings/grafana.key https://packages.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana
sudo wget -q https://raw.githubusercontent.com/josephgodwinkimani/systems-monitor/main/grafana.ini -O /etc/grafana/grafana.ini  
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/grafana-server
sudo systemctl start grafana-server 
sudo systemctl enable grafana-server.service
