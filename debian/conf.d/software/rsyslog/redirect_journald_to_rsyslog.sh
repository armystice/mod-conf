#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

apt-get -y install rsyslog

echo 'input(type="imuxsock" Socket="/run/systemd/journal/syslog")' > /etc/rsyslog.d/23-redirectjournald2rsyslog.conf
systemctl restart rsyslog

echo "[Journal]
Storage=none
ForwardToSyslog=yes
ReadKMsg=no
" > /etc/journald.conf.d/23-redirectjournald2rsyslog.conf
mkdir ${JOURNALD_TARGET_DIR} # Does not exist in default Debian installation
systemctl restart systemd-journald
