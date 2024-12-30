#!/bin/bash
# Parameters
DEB_CODENAME=bookworm
NTP_SERVERS="10.2.0.7" # Space-delimited
NTP_SRC_FILE=/etc/chrony/sources.d/custom.sources

# Reshade: curl -LO https://github.com/kevinlekiller/reshade-steam-proton/raw/main/reshade-linux.sh # There is also a fork at cyclermagic

echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee /etc/apt/sources.list.d/debian-backports.list
sudo apt update

echo "deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

# bookworm-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
"  | sudo tee /etc/apt/sources.list
sudo apt update

# Update kernel
# BROKEN 2024/12/26: apt -y install linux-image-amd64/bookworm-backports
sudo apt -y install nvidia-kernel-dkms # Instead of: apt install nvidia-driver
sudo apt -y install nvidia-cuda-toolkit

# BROKEN 2024/12/26: Install nvidia drivers (proprietary)
#wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
#dpkg -i cuda-keyring_1.1-1_all.deb
#apt-get update
#apt-get -y upgrade
#apt-get -y install cuda-toolkit nvidia-gds

sudo apt-get -y install firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-amd-graphics firmware-realtek

# Upgrade Debian's rng engine from Classic to new
sudo apt-get -y remove rng-tools-debian
sudo apt-get -y install rng-tools5

systemctl enable --now fstrim.timer

sudo apt-get -y install chrony

#NTP_SRC_FILE="/etc/chrony/sources.d/${NTP_SOURCE_NAME}.sources"
echo "" > ${NTP_SRC_FILE}
for ntpServer in ${NTP_SERVERS} # note that $var must NOT be quoted here!
do
   echo "server $ntpServer iburst" >> ${NTP_SRC_FILE}
done
echo "TODO: SET CHRONY SOURCES!"

# Install Power Management packages
echo "====================================="
echo "Updating Power Management packages..."
echo "====================================="
sudo apt-get -y install linux-cpupower linux-perf

# Install Power Management packages
echo "====================================="
echo "Updating Power Management packages..."
echo "====================================="
sudo apt-get -y install linux-cpupower linux-perf

# Security
apt-get -y install debian-security-support needrestart debsecan debsums fail2ban libpam-tmpdir apparmor
systemctl stop rsync
systemctl disable rsync

# Utilities
sudo apt-get -y install curl

# Redirect journald logging to rsyslog
sudo apt-get -y install rsyslog

echo 'input(type="imuxsock" Socket="/run/systemd/journal/syslog")' | sudo tee /etc/rsyslog.d/23-redirectjournald2rsyslog.conf
sudo systemctl restart rsyslog

echo "[Journal]
Storage=none
ForwardToSyslog=yes
ReadKMsg=no
" | sudo tee /etc/journald.conf.d/23-redirectjournald2rsyslog.conf
systemctl restart systemd-journald

# Debloat
apt-get -y remove cups
apt-get -y autoremove
apt-get -y autopurge

# Enable automatic security upgrades
apt-get -y install unattended-upgrades apt-listchanges apt-listbugs
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

# Extra repos
sudo apt-get -y install flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Gaming/ Remote Desktop
sudo apt install gamemode irqbalance

# Disable core dumps
echo "kernel.core_pattern=|/bin/false" | sudo tee /etc/sysctl.d/50-coredump.conf 
sudo sysctl -p

echo "root soft nofile 16384
root hard nofile 65536
root soft nproc 16384
root hard nproc 16384
root soft stack 10240
root hard stack 32768" | sudo tee /etc/security/limits.d/root.conf

echo "${USER} soft nofile 16384
${USER} hard nofile 65536
${USER} soft nproc 16384
${USER} hard nproc 16384
${USER} soft stack 10240
${USER} hard stack 32768" | sudo tee /etc/security/limits.d/${USER}.conf

echo "
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.vfs_cache_pressure = 50
vm.dirty_background_bytes = 4194304
vm.dirty_bytes = 4194304

net.core.netdev_max_backlog = 16384
net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.core.default_qdisc = cake

net.ipv4.ip_local_port_range = 30000 65535

net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_sack = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

" | sudo tee /etc/sysctl.d/23-gamingoptimisations.conf

# Set CPU governor
echo '# amd_pstate supported in kernel 6.3+
# CPU_DRIVER_OPMODE_ON_AC=active
# CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_AC=schedutil
PLATFORM_PROFILE_ON_AC=performance

DISK_DEVICES="nvme0n1 nvme1n1 sda sdb"
DISK_IOSCHED="none none mq-deadline mq-deadline"
' | sudo tee /etc/tlp.d/23-custom.conf

# Apply settings
sudo sysctl --system
sudo service tlp restart

echo "==== OTHER HINTS =====
- add amd_pstate=active to grub.conf
"


# See the following for passthrough: https://www.server-world.info/en/note?os=Debian_12&p=kvm&f=13