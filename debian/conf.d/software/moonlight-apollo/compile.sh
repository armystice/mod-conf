sudo apt-get -y install libssl-dev libcurl4-openssl-dev libminiupnpc-dev libboost-dev 
sudo apt-get -y install libenet-dev libdrm-dev libcap-dev libgraphviz-dev miniupnpc ffmpeg
sudo apt-get -y install libnotify-dev libayatana-appindicator3-dev libevdev2 libopus-dev xcb
sudo apt-get -y install libpulse-dev libavcodec-dev libavformat-dev libswscale-dev libxcb-xfixes0-dev
sudo apt-get -y install libfl-dev libnuma-dev

git clone --recurse-submodules https://github.com/ClassicOldSong/Apollo.git
cd Apollo
cmake . -DBUILD_DOCS=0
make
make install
