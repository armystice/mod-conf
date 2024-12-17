#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

cp "${SCRIPT_DIR}/pam.d_nx" /etc/pam.d/nx

NXSERVER_RUNNING=$(ps -fA | grep nxserver.bin | wc -l)
if [ "${NXSERVER_RUNNING}" -lt 1 ]; then
    dpkg -i "${SCRIPT_DIR}/nomachine_8.11.3_4_amd64.deb"
fi