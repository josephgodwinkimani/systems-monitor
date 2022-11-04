#!/bin/bash
# unattended installation - run baby run
# creating Prometheus System Users and Directory
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
cp -r /opt/prometheus-2.37.2.linux-amd64/consoles /etc/prometheus
cp -r /opt/prometheus-2.37.2.linux-amd64/console_libraries /etc/prometheus
cp -r /opt/prometheus-2.37.2.linux-amd64/prometheus.yml /etc/prometheus
#
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
# confirm installation
cat /etc/prometheus/prometheus.yml
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus 
#
# install grafana
wget -q -O /usr/share/keyrings/grafana.key https://packages.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install grafana
systemctl start grafana-server 
systemctl enable grafana-server.service

