#!/bin/bash
sudo apt purge `dpkg --list | grep ^rc | awk '{ print $2; }'`