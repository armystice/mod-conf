#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

apt-get -y install unbound
cp ${SCRIPT_DIR}/unbound.conf /etc/unbound/unbound.conf
systemctl restart unbound

ufw allow from 10.2.0.0/16 to any port 53 proto tcp
