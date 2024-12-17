#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

${SCRIPT_DIR}/setup-repo.sh
ufw allow from 10.2.89.0/24 to <server_ip> port 10000 proto tcp # todo: Parameterise this!

# todo: Enable full PAM conversations (ssee https://<host>:10000/webmin/edit_session.cgi?xnavigation=1)
# todo: Copy pam.d_webmin to /etc/pam.d/webmin once above is done