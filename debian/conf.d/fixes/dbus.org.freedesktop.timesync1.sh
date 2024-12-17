#!/bin/bash
# Fixes systemd error when dbus-org.freedesktop.timesync1.service fails to start because it points to a non-existent service under /lib
rm /etc/systemd/system/dbus-org.freedesktop.timesync1.service
systemctl mask dbus-org.freedesktop.timesync1.service
systemctl daemon-reload
