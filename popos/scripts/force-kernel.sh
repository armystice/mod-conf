#!/bin/bash

KERN_VER=6.8.0-45-generic

apt install 
kernelstub -k /boot/vmlinuz-${KERN_VER} -f -l -i /boot/initrd.img-${KERN_VER} -v