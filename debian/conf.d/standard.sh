#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

# Constants
SCRIPTS_ETC_DIR=$(readlink -f "${SCRIPT_DIR}/../../../debian/etc")

export CYCLERMAGIC_CONF_ROOT="${HOME}/.cyclermagic/settings"
mkdir -p "${CYCLERMAGIC_CONF_ROOT}"

export POST_INSTALL_NOTES=""

# Functions
function copy_conf_d_files() {
    SOURCE_D_DIR=$1
    TARGET_D_DIR=$2

    echo "copy_conf_d_files {Trying to copy ${SOURCE_D_DIR}/* -> ${TARGET_D_DIR}}"

    if [ -z "${SOURCE_D_DIR}" ] || [ "${SOURCE_D_DIR}" == "/" ]; then
        echo "conf.d copy failed: Source Dir (${SOURCE_D_DIR}) is empty or /"
        return 1
    fi
    if [ -z "${TARGET_D_DIR}" ] || [ "${TARGET_D_DIR}" == "/" ]; then
        echo "conf.d copy failed: Target Dir (${TARGET_D_DIR}) is empty or /"
        return 1
    fi

    if [ ! -d ${SOURCE_D_DIR} ]; then
        echo "conf.d copy failed: Source Dir (${SOURCE_D_DIR}) does not exist"
        return 1
    fi
    if [ ! -d ${TARGET_D_DIR} ]; then
        echo "conf.d copy failed: Target Dir (${TARGET_D_DIR}) does not exist"
        return 1
    fi

    cp ${SOURCE_D_DIR}/* ${TARGET_D_DIR}/
    chmod 644 ${SOURCE_D_DIR}/*
}

# Arguments
LOCALMAIL_USERNAME=$1
if [ -z "${LOCALMAIL_USERNAME}" ]; then
    echo "Exiting: Empty param 1 (LOCALMAIL_USERNAME)" 
    exit 1
fi

# NTP source name (prefix used in .sources file name)
NTP_SOURCE_NAME=$2
if [ -z "${NTP_SOURCE_NAME}" ]; then
    echo "Exiting: Empty param 2 (NTP_SOURCE_NAME)" 
    exit 1
fi

# Space-delimited NTP Server IPs/ Hostnames
# Example: 10.0.0.1 10.0.0.2 10.0.0.3
NTP_SERVERS=$3
if [ -z "${NTP_SERVERS}" ]; then
    echo "Exiting: Empty param 3 (NTP_SERVERS)" 
    exit 1
fi

SYSCTL_CONF_FILENAME=$4
if [ -z "${SYSCTL_CONF_FILENAME}" ]; then
    echo "Exiting: Empty param 4 (SYSCTL_CONF_FILENAME)" 
    exit 1
fi

# APT
source ${SCRIPT_DIR}/software/apt/install-default-sources.sh

# Kernel Parameters
ETC_SYSCTL_CONF="${SCRIPT_DIR}/../../../debian/etc/sysctl.d//${SYSCTL_CONF_FILENAME}"
cp "${ETC_SYSCTL_CONF}" "/etc/sysctl.d/"
systemctl restart systemd-sysctl

# Logging
echo "> Updating logging configuration..."

# all.conf files are deprecated for rsyslog and journald
rm /etc/rsyslog.d/23-all.conf
rm /etc/journald.conf.d/23-all.conf
source "${SCRIPT_DIR}/software/rsyslog/redirect_journald_to_rsyslog.sh"

# Drivers/ Firmware
apt-get -y install firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-amd-graphics firmware-realtek

# Upgrade Debian's rng engine from Classic to new
apt-get -y remove rng-tools-debian
apt-get -y install rng-tools5

# Utilities
apt-get -y install dnsutils deborphan

# Enable periodic TRIM
systemctl enable --now fstrim.timer

# Install ntp
echo "> Configuring NTP..."
apt-get -y remove ntp
apt-get -y install chrony

NTP_SRC_FILE="/etc/chrony/sources.d/${NTP_SOURCE_NAME}.sources"
echo "" > ${NTP_SRC_FILE}
for ntpServer in ${NTP_SERVERS} # note that $var must NOT be quoted here!
do
   echo "server $ntpServer iburst" >> ${NTP_SRC_FILE}
done

service chrony force-reload

# Enable auto-upgrades
echo "> Enabling auto-upgrades..."

apt-get -y install unattended-upgrades apt-listchanges apt-listbugs
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

# Enable upgrade mail notifications
# todo: Fix and test ${LOCALMAIL_USERNAME}
# sed -i 's/#Unattended-Upgrade::Mail "";/#Unattended-Upgrade::Mail "${LOCALMAIL_USERNAME}";/g' /etc/apt/apt.conf.d/50unattended-upgrades

# .d config copying

# MOTD disabled (2024/09/14)
#
# echo "> Updating MOTD Scripts..."
# UPDATEMOTD_SOURCE_DIR="${SCRIPTS_ETC_DIR}/update-motd.d"
# UPDATEMOTD_TARGET_DIR=/etc/update-motd.d
# copy_conf_d_files ${UPDATEMOTD_SOURCE_DIR} ${UPDATEMOTD_TARGET_DIR}

echo "> Updating sshd_config.d Scripts..."
SSHD_SOURCE_DIR="${SCRIPTS_ETC_DIR}/sshd_config.d"
SSHD_TARGET_DIR=/etc/ssh/sshd_config.d
copy_conf_d_files ${SSHD_SOURCE_DIR} ${SSHD_TARGET_DIR}
service sshd restart

apt-get update

# Install Power Management packages
echo "====================================="
echo "Updating Power Management packages..."
echo "====================================="
apt-get -y install linux-cpupower linux-perf tlp

# Security
apt-get -y install debian-security-support needrestart debsecan debsums fail2ban libpam-tmpdir apparmor
systemctl stop rsync
systemctl disable rsync

# Utilities
apt-get -y install curl

# Monitoring
source "${SCRIPT_DIR}/software/monit/install.sh"

# Debloat
apt-get -y remove cups
apt-get -y autoremove
apt-get -y autopurge

echo "${POST_INSTALL_NOTES}"