#!/bin/bash
echo "Tested on nvidia-565 drivers"
sudo setcap -r $(readlink -f $(which sunshine))