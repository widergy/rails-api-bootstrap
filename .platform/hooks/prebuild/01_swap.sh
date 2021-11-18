#!/bin/bash

SWAPFILE=/var/swapfile

# Check if swap file already exists
if [ -f $SWAPFILE ]; then
  echo "Swapfile $SWAPFILE found, assuming it's already setup"
  exit;
fi

# Create swap space
sudo dd if=/dev/zero of=$SWAPFILE bs=1M count=512
sudo /sbin/mkswap $SWAPFILE
sudo chmod 600 $SWAPFILE
sudo /sbin/swapon $SWAPFILE
