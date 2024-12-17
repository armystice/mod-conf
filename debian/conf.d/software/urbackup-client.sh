TF=$(mktemp) && wget "https://hndl.urbackup.org/Client/2.5.25/UrBackup%20Client%20Linux%202.5.25.sh" -O $TF && sudo sh $TF; rm -f $TF

ufw allow from 10.2.0.0/16 to 10.2.0.0/16 port 35621 proto tcp comment "urbackup"
ufw allow from 10.2.0.0/16 to 10.2.0.0/16 port 35622 proto udp comment "urbackup"
ufw allow from 10.2.0.0/16 to 10.2.0.0/16 port 35623 proto tcp comment "urbackup"