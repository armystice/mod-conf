#!/bin/bash
apt install moosefs-client
sudo mkdir /mnt/mfs

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "! # If Master add the following to /etc/fstab:                                !"
echo "! mfsmount /mnt/mfs fuse defaults,mfsdelayedinit,mfsmaster=mfsmaster 0 0      !"
echo "!                                                                             !"
echo "! # Otherwise:                                                                !"
echo "! mfsmount /mnt/mfs fuse defaults,nofail,mfsmaster=mfsmaster,mfsport=9421,mfsdelayedinit 0 0        !"                                                                      !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"