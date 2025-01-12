#!/bin/bash
apt install -y monitorix

echo 'base_url = /
base_cgi = /

<httpd_builtin>
    enabled = y
    host = 0.0.0.0
    port = 5199
</http_builtin>
' > /etc/monitorix/conf.d/23-armystice.conf
service monitorix restart

echo -e 'If you have ufw please do (change 10.2.0.0/16 to your network): 
ufw allow from 10.2.0.0/16 to 10.2.0.0/16 port 5199 proto tcp comment "monitorix"'