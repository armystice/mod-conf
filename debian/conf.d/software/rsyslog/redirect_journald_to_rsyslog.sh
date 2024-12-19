#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

source "${SCRIPT_DIR}/install.sh"

cp ${SCRIPT_DIR}/rsyslog.d/* /etc/rsyslog.d/
systemctl restart rsyslog

cp ${SCRIPT_DIR}/journald.conf.d/* /etc/journald.conf.d/
mkdir ${JOURNALD_TARGET_DIR} # Does not exist in default Debian installation
systemctl restart systemd-journald
