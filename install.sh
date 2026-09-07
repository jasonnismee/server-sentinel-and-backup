#!/bin/bash
set -euo pipefail

INSTALL_DIR='/opt/server-sentinel'
CONFIG_DIR="/etc/sentinel"

echo "Khoi tao cau truc thu muc"
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$CONFIG_DIR"
sudo mkdir -p "/var/log/sentinel"

echo "Copy cau hinh vao $CONFIG_DIR"
if [[ ! -f "$CONFIG_DIR/sentinel.env" ]]; then
	sudo cp config/sentinel.env.example "$CONFIG_DIR/sentinel.env"
fi
sudo chmod 600 "$CONFIG_DIR/sentinel.env"

echo "Copy ma nguon vao $INSTALL_DIR"
sudo cp -r scripts "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/scripts/"*.sh

echo "Cai dat systemd service va timer"
sudo cp systemd/*.service systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now sentinel-collector.timer
sudo systemctl enable --now sentinel-backup.timer

echo "Cai dat hoan tat!"
