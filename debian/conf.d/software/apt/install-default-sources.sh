#!/bin/bash
echo "deb http://mirrorservice.org/sites/ftp.debian.org/debian/ bookworm main non-free-firmware
deb-src http://mirrorservice.org/sites/ftp.debian.org/debian/ bookworm main non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware

# bookworm-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://mirrorservice.org/sites/ftp.debian.org/debian/ bookworm-updates main non-free-firmware
deb-src http://mirrorservice.org/sites/ftp.debian.org/debian/ bookworm-updates main non-free-firmware
" > /etc/apt/sources.list
apt-get update
