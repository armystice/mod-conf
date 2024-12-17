# Constants
FILE_BLACKLIST_NOUV=/etc/modprobe.d/blacklist-nouveau.conf
FILE_MODPROBE_NVKERNCOMMON=/etc/modprobe.d/nvidia-kernel-common.conf

apt install nvidia-settings

FOUND_BLACKLIST_NOUV=$(grep "blacklist nouveau" ${FILE_BLACKLIST_NOUV} | wc -l)
FOUND_OPTIONS_MODESET=$(grep "options nouveau modeset=0" ${FILE_BLACKLIST_NOUV} | wc -l)

FOUND_MODESET_NVDRMSET=$(grep "options nvidia-drm modeset=1" ${FILE_MODPROBE_NVKERNCOMMON} | wc -l)

REBOOT_REQUIRED=0
if [ "${FOUND_BLACKLIST_NOUV}" -eq 0 ]; then
    echo "blacklist nouveau" > ${FILE_BLACKLIST_NOUV}
    REBOOT_REQUIRED=1
fi
if [ "${FOUND_OPTIONS_MODESET}" -eq 0 ]; then
    echo "options nouveau modeset=0" > ${FILE_BLACKLIST_NOUV}
    REBOOT_REQUIRED=1
fi
if [ "${FOUND_MODESET_NVDRMSET}" -eq 0 ]; then
    echo "options nvidia-drm modeset=1" > ${FILE_MODPROBE_NVKERNCOMMON}
    REBOOT_REQUIRED=1
fi

if [ "${REBOOT_REQUIRED}" == 1 ]; then
    update-initramfs -u -k all
    echo "Please REBOOT your system to apply fixes"
fi