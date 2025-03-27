## 📘 `README.md`

# Prometheus + Node Exporter Installer

This repository contains a one-shot installation script to set up:

- ✅ Prometheus (v2.52.0)
- ✅ Node Exporter (v1.8.1)
- ✅ Systemd services for both
- ✅ Pre-configured `prometheus.yml` to scrape metrics

---
![image](https://github.com/user-attachments/assets/3f89c844-410b-4633-8894-cea4423068c0)

## 📦 Requirements

- Debian 12 / Ubuntu 20.04+ (tested)
- Root or sudo access
- Internet connection to fetch binaries

---

## 🚀 Installation

Clone the repo and run:

```bash
chmod +x install-prometheus-nodeexporter.sh
sudo ./install-prometheus-nodeexporter.sh
```

---

## 📈 Result

- Prometheus available at: `http://<your-server-ip>:9090`
- Node Exporter metrics at: `http://<your-server-ip>:9100/metrics`

Both services are started and enabled to run at boot.

---
## 📊 Grafana Setup (Optional but Recommended)

If you're using **Grafana** for visualization:

1. Install Grafana from [grafana.com](https://grafana.com/grafana/download)
2. Access Grafana at: `http://<your-grafana-ip>:3000`
3. Login (`admin/admin`) and change password
4. Add a **Prometheus** data source:
   - URL: `http://<monitored-node-ip>:9090`
   - Name it like: `prometheus-media01`
5. Import a dashboard:
   - Recommended: **Node Exporter Full** (Dashboard ID: `1860` from Grafana.com)

Now you’ll see real-time metrics: CPU, memory, disk, network, and more — just like `htop`, but beautiful.

---
## 🛠️ Notes

- Prometheus scrapes `localhost:9090` and `localhost:9100` by default.
- You can modify targets in `/etc/prometheus/prometheus.yml`.

---

## 🙌 Author

Made with ❤️ by Umair for Grafana-Asterisk server monitoring.
