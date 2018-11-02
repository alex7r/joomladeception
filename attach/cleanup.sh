#!/usr/bin/env bash

apt-get clean
dd if=/dev/zero of=/EMPTY bs=1M
sync
rm -f /EMPTY
sync
cat /dev/null > ~/.bash_history && history -c