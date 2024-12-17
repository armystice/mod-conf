#!/bin/bash
HEADSCALE_VERSION="0.22.3"
HEADSCALE_ARCH="amd64"
wget --output-document=/tmp/headscale.deb \
  "https://github.com/juanfont/headscale/releases/download/v${HEADSCALE_VERSION}/headscale_${HEADSCALE_VERSION}_linux_${HEADSCALE_ARCH}.deb"

apt install /tmp/headscale.deb
systemctl enable headscale

echo "
" > /etc/headscale/config.yaml