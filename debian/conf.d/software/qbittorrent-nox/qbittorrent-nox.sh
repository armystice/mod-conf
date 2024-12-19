#!/bin/bash
SCRIPT_FILE=$(readlink -f $0)
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

apt install qbittorrent-nox
mkdir -p ~/.config/qBittorrent
cp "${SCRIPT_DIR}/.confqBitorrent.conf" .config/qBittorrent/qBittorrent.conf

adduser qbittorrent-nox
passwd -l qbittorrent-nox

MFS_DIR=/mnt/mfs/qbittorrent/$(hostname -s)
mkdir -p "${MFS_DIR}"
chown -R qbittorrent-nox /mnt/mfs/qbittorrent/
apt install qbittorrent-nox

cp "${SCRIPT_DIR}/qbittorrent-nox.service" /etc/systemd/system/
chown qbittorrent-nox /etc/systemd/system/qbittorrent-nox.service

systemctl daemon-reload
systemctl enable qbittorrent-nox

echo "Accept the agreement by pressing y and then enter:"
qbittorrent-nox

systemctl start qbittorrent-nox

ufw allow from 10.2.0.0/16 to any port 5120 proto tcp comment "qbittorrent-nox"