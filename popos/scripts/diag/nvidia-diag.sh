#!/bin/bash
apt install inxi

echo "BOOT DIAG:"
dmesg | grep -A10 -B10 -i NVIDIA

echo "XSERVER DIAG:"
echo "============="
echo $XDG_SESSION_TYPE && glxinfo | grep server
echo "\n"

echo "INXI DIAG:"
echo "=========="
inxi --admin --verbosity=7 --filter --no-host --width
echo "\n"

echo "MODESET DIAG:"
echo "============="
cat /sys/module/nvidia_drm/parameters/modeset