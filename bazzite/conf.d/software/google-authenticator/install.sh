#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

dnf install -y google-authenticator

cp "${SCRIPT_DIR}/30-google-authenticator.conf" /etc/ssh/sshd_config.d/

service sshd restart

echo "Setup steps:"
echo "1) Run the following for your user: google-authenticator"
echo "2) mv /home/${USER}/.google_authenticator /home/${USER}/.ssh/"
echo "3) Now attempt to ssh login from a different session!"
