#!/bin/bash
echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware\n" > /etc/apt/sources.list.d/debian-backports.list
apt-get update