#!/usr/bin/env bash

sudo apt-get clean
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
sudo rm -rf /docker-attach
cat /dev/null > ~/.bash_history && history -c