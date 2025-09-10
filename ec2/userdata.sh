#!/bin/bash -ex
Log=/tmp/userdata.log
echo "Enter" >> $Log

echo "Try apt update and upgrade" >> $Log
sudo apt update --yes
sudo apt upgrade --yes

echo "Try install packages" >> $Log
sudo apt install --yes apache2 php8.3 zip git curl

echo "Try download from GitHub" >> $Log
# Run as ubuntu user.
su -l ubuntu << END
  curl https://raw.githubusercontent.com/evanychu/shell-alias/refs/heads/main/shell-alias > .bash_aliases
  git clone https://github.com/evanychu/website-infra.git
END

echo "Exit" >> $Log
