adduser --disabled-password --gecos "" docker-rootless
su - docker-rootless <<"EOF" #todo: FIX!
    systemctl --user stop docker
    rm -f ~/bin/dockerd 
    curl -fsSL https://get.docker.com/rootless | sh
EOF