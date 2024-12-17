#!/bin/bash
sudo ufw allow from 10.2.89.0/24 to 10.2.10.1/32 port 139 proto tcp comment "SMB"
sudo ufw allow from 10.2.89.0/24 to 10.2.10.1/32 port 445 proto tcp comment "SMB"