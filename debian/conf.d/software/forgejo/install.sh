#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

wget https://codeberg.org/forgejo/forgejo/releases/download/v9.0.3/forgejo-9.0.3-linux-amd64
chmod +x forgejo-9.0.3-linux-amd64

gpg --keyserver keys.openpgp.org --recv EB114F5E6C0DC2BCDD183550A4B61A2DC5923710
wget https://codeberg.org/forgejo/forgejo/releases/download/v9.0.3/forgejo-9.0.3-linux-amd64.asc
gpg --verify forgejo-9.0.3-linux-amd64.asc forgejo-9.0.3-linux-amd64

cp forgejo-9.0.3-linux-amd64 /usr/local/bin/forgejo
chmod 755 /usr/local/bin/forgejo
apt install git git-lfs
adduser --system --shell /bin/bash --gecos 'Git Version Control' \
  --group --disabled-password --home /home/git git

mkdir /mnt/mfs/forgejo
chown git:git /mnt/mfs/forgejo && chmod 750 /mnt/mfs/forgejo

mkdir /etc/forgejo
chown root:git /etc/forgejo && chmod 770 /etc/forgejo

cp ${SCRIPT_DIR}/app.ini /etc/forgejo/

cp ${SCRIPT_DIR}/forgejo.service /etc/systemd/system/forgejo.service
mkdir /var/log/forgejo
chown git /var/log/forgejo

systemctl enable forgejo.service
systemctl start forgejo.service

ufw allow from 10.2.0.0/16 to any port 3000 proto tcp comment "forgejo git server" # forgejo git server

echo "
In the initial setup page set the following:
SSH server port=22
Log path=/var/log/forgejo
"