#!/bin/bash
# Download fresh script 
clear
curl -o syncnode.py -LJO https://github.com/jacklevin74/xenminer/raw/main/syncnode.py
echo

if [ -z "$1" ]; then
  echo "Please provide an address as an argument."
  exit 1
fi

account="$1"
echo "Starting synchronization using account: $account"
while sleep 60; do python3 syncnode.py "$account"; done
