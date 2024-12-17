# todo!
HOMEBRIDGE_INSTALLED=$(apt list --installed | egrep "^homebridge/unknown," | wc -l)
if [ "${HOMEBRIDGE_INSTALLED}" -lt 1 ]; then
    # Install Homebridge
    /usr/bin/curl -sSfL https://repo.homebridge.io/KEY.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/homebridge.gpg  > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/homebridge.gpg] https://repo.homebridge.io stable main" | sudo tee /etc/apt/sources.list.d/homebridge.list > /dev/null

    apt-get update
    apt-get install homebridge
fi

# Upgrades node, if necessary
hb-service update-node
service homebridge restart