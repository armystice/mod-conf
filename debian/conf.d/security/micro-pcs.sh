#!/bin/bash
echo "$ $(basename $(readlink -f ${BASH_SOURCE[0]}))..."

apt-get -y install debian-security-support needrestart debsecan debsums fail2ban libpam-tmpdir
apt-get -y install usbguard
apt-get -y install lynis

# Install Anti-malware tools
apt-get -y install rkhunter

# Ensure clamdscan is not installed
echo "Removing clamav (causes constant high CPU usage on low spec machines)"
apt-get -y remove clamdscan
apt-get -y autoremove

# Install auditing/ accounting tools
apt-get -y install auditd audispd-plugins sysstat acct

# Enable process accounting
/usr/sbin/accton on

AIDE_INSTALLED=$(apt list --installed | egrep "^aide/stable," | wc -l)
if [ "${AIDE_INSTALLED}" -lt 1 ]; then
    # Install AIDE

    apt-get -y install aide
    sed -i 's/#CRON_DAILY_RUN=/CRON_DAILY_RUN=/g' /etc/default/aide
    aide --init --config /etc/aide/aide.conf
    cp -p /var/lib/aide/aide.db.new /var/lib/aide/aide.db
    aide --check --config /etc/aide/aide.conf
fi

APACHE_INSTALLED=$(sudo apt list --installed | grep apache2 | wc -l)
if [ "${APACHE_INSTALLED}" -gt 0 ]; then
    # Enable Apache 2 mod_security
    apt-get install -y libapache2-mod-security2 libapache2-mod-evasive
    a2enmod headers
    systemctl restart apache2
fi