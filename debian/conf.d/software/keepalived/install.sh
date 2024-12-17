#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

ROUTE_GATEWAY=$1
if [ -z "${ROUTE_GATEWAY}" ]; then
    echo '$1/ ROUTE_GATEWAY not set'
    exit 1
fi

apt-get -y install keepalived
cp ${SCRIPT_DIR}/keepalived.conf /etc/keepalived/keepalived.conf # todo: set correct interface etc
cp ${SCRIPT_DIR}/keepalived_check_gateway_internet.sh /usr/local/bin/keepalived_check_gateway_internet.sh

# Add route so the script goes via the host's gateway
route delete -net 192.203.230.10
route add -net 192.203.230.10 netmask 255.255.255.255 gw ${ROUTE_GATEWAY}

systemctl restart keepalived