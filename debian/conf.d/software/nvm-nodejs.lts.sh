apt-get -y install curl

/usr/bin/curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install --lts
nvm use --lts
nvm alias default node # todo: Find a way to determine the current LTS (latest could be unstable, if installed)