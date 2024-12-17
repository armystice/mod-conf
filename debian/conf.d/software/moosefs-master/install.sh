#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

function install_cfg() {
    cfg_dir=$1
    cfg_file=$2

    cp -n "${SCRIPT_DIR}/$cfg_file" "$cfg_dir/$cfg_file"
}

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "! CHECK THIS HOST IS PART OF DNS A RECORD mfsmaster       !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

apt -y install moosefs-master moosefs-cgi moosefs-cgiserv moosefs-cli
cp "${SCRIPT_DIR}/mfsmaster.cfg" /etc/mfs/
cp "${SCRIPT_DIR}/mfsexports.cfg" /etc/mfs/ #todo: Accept subnet as parameter

ufw allow from 10.2.0.0/16 to any port 9419:9421 proto tcp comment "mfs master" # Master
ufw allow from 10.2.0.0/16 to any port 9422 proto tcp comment "mfs chunk server" # Chunk Servers
ufw allow from 10.2.0.0/16 to any port 9425 proto tcp comment "mfs cgi server" # CGI Server

mfsmaster -a start
mfsmaster -a stop
# moosefs GLP only supports one master
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "! IF SERVER=master: Enable moosefs-master and start       !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

# Setup moosefs-metalogger
apt -y install moosefs-metalogger
install_cfg /etc/mfs mfsmetalogger.cfg
install_cfg /etc/default moosefs-metalogger
systemctl enable moosefs-metalogger
systemctl start moosefs-metalogger

# Setup moosefs-chunkserver
apt -y install moosefs-chunkserver
install_cfg /etc/mfs mfschunkserver.cfg
install_cfg /etc/mfs mfshdd.cfg
systemctl enable moosefs-chunkserver
systemctl start moosefs-chunkserver

# TODO: Change permissions of chunk server partition
# MFS_MNT_NAME=MOUNT_NAME_GOES_HERE
# sudo mkdir /mnt/${MFS_MNT_NAME}/mfs
# sudo chown -R mfs:mfs /mnt/${MFS_MNT_NAME}/mfs

# Setup moosefs-cgiserv
install_cfg /etc/default moosefs-cgiserv
systemctl enable moosefs-cgiserv
systemctl start moosefs-cgiserv

# Setup moosefs-client
apt -y install moosefs-client
mkdir /mnt/mfs
mfsmount /mnt/mfs -H mfsmaster

mfssetgoal -r 2 /mnt/mfs

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "! # If Master add the following to /etc/fstab:                                !"
echo "! mfsmount /mnt/mfs fuse defaults,mfsdelayedinit,mfsmaster=mfsmaster 0 0      !"
echo "!                                                                             !"
echo "! # Otherwise:                                                                !"
echo "! mfsmount /mnt/mfs fuse defaults,nofail,mfsmaster=mfsmaster,mfsport=9421,mfsdelayedinit 0 0        !"                                                                      !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"