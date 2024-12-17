#!/bin/bash
# Adapted from https://medium.com/@piash.tanjin/why-do-we-need-ipfs-and-how-to-create-private-ipfs-network-c595bf00afc6
SCRIPT_FILE=$(readlink -f $0)
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

KUBO_VER="0.28.0"
KUBO_TAR="kubo_v${KUBO_VER}_linux-amd64.tar.gz"

function ipfs_installed() {
    echo "$(/usr/local/bin/ipfs --version | wc -l)"
}
function ipfs_user_exists() {
    echo "$(grep ipfs: /etc/passwd | wc -l)"
}

sudo apt install golang

if [ "$(ipfs_installed)" -eq 1 ]; then
    echo "        + ipfs FOUND +"
else
    echo "        - ipfs NOT FOUND -"
    cd /tmp

    rm ${KUBO_TAR}
    rm -rf /tmp/kubo

    wget https://dist.ipfs.tech/kubo/v${KUBO_VER}/${KUBO_TAR}
    tar xvf "${KUBO_TAR}"
    cd kubo
    bash install.sh
fi
if [ "$(ipfs_installed)" -eq 1 ]; then
    echo "        + ipfs FOUND +"
else
    echo "        ! ipfs NOT FOUND after installation !"
    exit 1
fi

IPFS_USER_EXISTS=$(grep ipfs: /etc/passwd | wc -l)
if [ "$(ipfs_user_exists)" -ne 1 ]; then
    echo "          CREATING ipfs user"
    adduser --disabled-password --gecos "" ipfs

    if [ "$(ipfs_user_exists)" -ne 1 ]; then
        echo "        ! ipfs user NOT CREATED !"
        exit 1
    fi
fi
echo "        + ipfs user CREATED +"

ufw allow from 10.2.0.0/16 to any port 4001 proto tcp
ufw allow from 10.2.0.0/16 to any port 5115 proto tcp
ufw allow from 10.2.0.0/16 to any port 5116 proto tcp

mkdir -p /home/ipfs/.ipfs
go run ${SCRIPT_DIR}/swarm-keygen/main.go > /home/ipfs/.ipfs/swarm.key
chown -R ipfs /home/ipfs/.ipfs
sudo -H -u ipfs bash -c "
    /usr/local/bin/ipfs init
    /usr/local/bin/ipfs bootstrap rm all
    /usr/local/bin/ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/5116
    /usr/local/bin/ipfs config Addresses.API /ip4/0.0.0.0/tcp/5115
"

# Install service
SYSTEMCTL_USER_INSTALL="${SCRIPT_DIR}/../systemctl-user/install.sh"
${SYSTEMCTL_USER_INSTALL} ipfs

IPFS_SVC_FILE="${SCRIPT_DIR}/ipfs.service"
cp "${IPFS_SVC_FILE}" .config/systemd/user/
chown ipfs ".config/systemd/user/${IPFS_SVC_FILE}"