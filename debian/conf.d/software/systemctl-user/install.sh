#!/bin/bash
SCRIPT_FILE=$(readlink -f $0)
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

TARGET_USER=$1
if [ -z "${TARGET_USER}" ]; then
    echo "${SCRIPT_FILE} failed: 0/ TARGET_USER is not set"
    exit 1
fi

loginctl enable-linger "${TARGET_USER}"
sudo -H -u "${TARGET_USER}" bash -c "
        mkdir -p ~/.config/systemd/user
    "

BASHRC_MARKER="cyclermagic: systemctl --user setup 2024.06.07"
BASHRC_UPDATED=$(grep "# > ${BASHRC_MARKER}" "/home/${TARGET_USER}/.bashrc" | wc -l)
if [ "${BASHRC_UPDATED}" -eq 0 ]; then
    echo "          configuring .bashrc"
    echo "# > ${BASHRC_MARKER}" >> "/home/${TARGET_USER}/.bashrc"

    echo '
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
    ' >> "/home/${TARGET_USER}/.bashrc"

    echo "# < ${BASHRC_MARKER}" >>  "/home/${TARGET_USER}/.bashrc"
else
    echo "        + .bashrc already configured"
fi