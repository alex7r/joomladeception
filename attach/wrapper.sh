#!/bin/bash

service apache2 start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apache2: $status"
  exit $status
fi

service mysql start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start mysql: $status"
  exit $status
fi

while /bin/true; do
  PROCESS_1_STATUS=$(ps aux |grep -q apache2 |grep -v grep)
  PROCESS_2_STATUS=$(ps aux |grep -q mysql | grep -v grep)
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  sleep 60
done