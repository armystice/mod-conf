#!/bin/bash
# Pings one of the E Root Servers hosted by the NASA Ames Research Center
/usr/bin/ping -c 3 -W 3 192.203.230.10 > /dev/null 2>&1
