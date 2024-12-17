#!/bin/bash
# TODO: Generalise

EXPORTS_MFS_SETUP=$(grep "/mnt/mfs" /etc/exports | wc -l)
if [ "${EXPORTS_MFS_SETUP}" -lt 1 ]; then
  echo "/mnt/mfs 10.2.0.0/16(rw,sync,no_subtree_check,root_squash,fsid=0)" >> /etc/exports
fi
exportfs -a
systemctl restart nfs-kernel-server

# TODO: /etc/nfs.conf change one setting =y to =n
echo "Run the following:
ufw allow from 10.2.0.0/16 to <ip>/32 port 2049 proto tcp
ufw allow from 10.2.0.0/16 to <ip>/32 port 2049 proto udp

ufw allow from 10.2.0.0/16 to <ip>/32 port 111 proto tcp
ufw allow from 10.2.0.0/16 to <ip>/32 port 111 proto udp

ufw allow from 10.2.0.0/16 to <ip>/32 port 1520,1522,1523 proto tcp
ufw allow from 10.2.0.0/16 to <ip>/32 port 1521 proto udp

sudo ufw allow from 10.2.89.0/24 to <ip>/32 port 32768:60999 proto tcp
sudo ufw allow from 10.2.89.0/24 to <ip>/32 port 32768:60999 proto udp
"