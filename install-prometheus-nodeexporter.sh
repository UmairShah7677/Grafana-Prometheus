#!/bin/bash

set -e

PROM_VERSION="2.52.0"
NODE_EXPORTER_VERSION="1.8.1"

echo "🚀 Installing Prometheus $PROM_VERSION and Node Exporter $NODE_EXPORTER_VERSION"

# Create required dirs
mkdir -p /etc/prometheus /var/lib/prometheus

# --- Install Prometheus ---
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xzf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
cd prometheus-${PROM_VERSION}.linux-amd64

cp prometheus promtool /usr/local/bin/
cp -r consoles console_libraries /etc/prometheus/

# --- Generate prometheus.yml ---
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF

# --- Prometheus systemd service ---
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --web.listen-address=0.0.0.0:9090 \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# --- Install Node Exporter ---
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cd node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
cp node_exporter /usr/local/bin/

# --- Node Exporter systemd service ---
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# --- Enable and start both services ---
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now prometheus node_exporter

# --- Confirm
echo "✅ Prometheus running on port 9090"
echo "✅ Node Exporter running on port 9100"
echo "🔁 Visit http://<this-server-ip>:9090 in browser to confirm"
