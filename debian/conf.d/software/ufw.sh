apt-get -y install ufw
ufw allow from 10.2.0.0/16 to any port 1506 proto tcp
ufw allow from 10.2.0.0/16 to any port 9090 proto tcp
ufw default deny incoming
ufw default allow outgoing
ufw enable
ufw status