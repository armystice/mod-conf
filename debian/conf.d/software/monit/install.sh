#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

apt install -y monit lm-sensors
echo -e "If you have not done so already, please run: 
1) sensors-detect
2) service monit restart"

cp ${SCRIPT_DIR}/armystice.conf /etc/monit/conf.d/armystice.conf
service monit restart