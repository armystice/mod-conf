#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

echo "$ $(basename $(readlink -f ${BASH_SOURCE[0]}))..."

apt-get -y install debian-security-support needrestart debsecan debsums fail2ban libpam-tmpdir apparmor
apt-get -y install usbguard
apt-get -y install lynis
apt-get -y install openscap-scanner openscap-utils bzip2 

# Reduce attack surface (insecure services)
apt-get -y --purge remove xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server
apt-get -y --purge remove avahi-daemon rpcbind

systemctl stop rsync
systemctl disable rsync

# Reduce attack surface (scanners)
apt-get -y remove libsane1

# Reduce attack surface (bluetooth)
apt-get -y remove bluedevil bluez

# Reduce attack surface (CUPS)
apt-get -y remove cups

# Reduce attack surface (ModemManager)
apt-get -y remove ModemManager

# Reduce attack surface (WiFi)
# nmcli radio wifi off

# Reduce attack surface (promiscuous mode)
# todo: ip link set ifgoeshere promisc off
# todo: nmcli connection modify ifgoeshere ethernet.accept-all-mac-addresses no

# Cleanup unnecessary dependencies
apt-get -y autoremove
apt-get -y autopurge

# Install Anti-malware tools
apt-get -y install clamdscan clamav-freshclam rkhunter

# 2025/01/11: ClamAV daemon removed because of excessive CPU and RAM usage
apt-get -y remove clamav-daemon
# source "${SCRIPT_DIR}/../fixes/clamd_highram_fixes.sh"
# systemctl enable clamav-daemon
# systemctl restart clamav-daemon # Restart in case fixes were applied

# Uses excessive CPU and the service has failed to start in 2023/2024
systemctl disable clamav-clamonacc.service

echo "0 6 * * 1,3,6 root /usr/bin/freshclam; /usr/bin/clamscan -i /* > /var/log/clamav/clamdscan_scheduled.$(date +%Y%M%d).log" | sudo tee /etc/cron.d/clamdscan_scheduled

# Install IDS/ IPS tools
curl -s https://install.crowdsec.net | sudo sh
apt-get update
apt-get -y install crowdsec
cscli collections install crowdsecurity/linux
cscli collections install crowdsecurity/linux-lpe
cscli collections install crowdsecurity/apiscp
cscli collections install crowdsecurity/base-http-scenarios
cscli collections install crowdsecurity/appsec-generic-rules
cscli collections install crowdsecurity/auditd
cscli collections install crowdsecurity/appsec-virtual-patching
cscli collections install crowdsecurity/apache2
cscli collections install crowdsecurity/appsec-crs
cscli collections install crowdsecurity/exim
cscli collections install crowdsecurity/modsecurity
cscli collections install crowdsecurity/nginx
cscli collections install crowdsecurity/postfix
cscli collections install crowdsecurity/smb
cscli collections install crowdsecurity/sshd
cscli collections install crowdsecurity/sshd-impossible-travel
cscli collections install crowdsecurity/teamspeak3
cscli collections install crowdsecurity/whitelist-good-actors
cscli collections install crowdsecurity/wireguard
cscli collections install crowdsecurity/caddy
apt-get install -y crowdsec-firewall-bouncer-iptables

systemctl restart crowdsec

# Install auditing/ accounting tools
apt-get -y install auditd audispd-plugins sysstat acct

# Enable process accounting
/usr/sbin/accton on

# Enable sysstat
echo "ENABLED=\"true\"\n" | sudo tee /etc/default/sysstat
systemctl start sysstat
systemctl enable sysstat

# --- AIDE removed 2024/08/15 -----------------------------------------------
#    AIDE_INSTALLED=$(apt list --installed | egrep "^aide/stable," | wc -l)
#    if [ "${AIDE_INSTALLED}" -lt 1 ]; then
#        # Install AIDE
#
#        apt-get -y install aide
#        sed -i 's/#CRON_DAILY_RUN=/CRON_DAILY_RUN=/g' /etc/default/aide
#        aide --init --config /etc/aide/aide.conf
#        cp -p /var/lib/aide/aide.db.new /var/lib/aide/aide.db
#        aide --check --config /etc/aide/aide.conf
#    fi
apt-get -y purge aide
# ---------------------------------------------------------------------------

APACHE_INSTALLED=$(sudo apt list --installed | grep apache2 | wc -l)
if [ "${APACHE_INSTALLED}" -gt 0 ]; then
    # Enable Apache 2 mod_security
    apt-get install -y libapache2-mod-security2 libapache2-mod-evasive
    a2enmod headers
    systemctl restart apache2
fi

# Set sudoers file permissions
chown -c root:root /etc/sudoers
chmod -c 0440 /etc/sudoers

chown -c root:root /etc/sudoers.d
chmod -c 0440 /etc/sudoers.d

chown -c root:root /etc/sudoers.d/*
chmod -c 0440 /etc/sudoers.d/*

# Only allow root to use compilers
# chmod o-rx /usr/bin/gcc
# chmod o-rx /usr/bin/gcc*
# chmod o-rx /usr/bin/g++
# chmod o-rx /usr/bin/g++*

# Undone (too restrictive in some configurations)
chmod o+rx /usr/bin/gcc
chmod o+rx /usr/bin/gcc*
chmod o+rx /usr/bin/g++
chmod o+rx /usr/bin/g++*
