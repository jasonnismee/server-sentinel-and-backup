#!/bin/bash
set -euo pipefail

INSTALL_DIR='/opt/server-sentinel'
LOG_DIR='/var/log/sentinel'

echo "Khoi tao cau truc thu muc"
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$LOG_DIR"

echo "Copy ma nguon vao $INSTALL_DIR"
sudo cp -r scripts "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/scripts/"*.sh

echo "Cai dat systemd service va timer"
sudo cp systemd/sentinel-collector.service /etc/systemd/system/
sudo cp systemd/sentinel-collector.timer /etc/systemd/system/

echo "Kich hoat systemd timer"
sudo systemctl daemon-reload
sudo systemctl enable --now sentinel-collector.timer

echo "Cai dat hoan tat!"
