#!/bin/bash
swapFile=/mnt/swapfile
fallocate -l 8G $swapFile
chmod 600 $swapFile
mkswap $swapFile
swapon $swapFile
isPresentInfstab=$(grep "$swapFile" /etc/fstab -c)
if [ $isPresentInfstab -eq 0 ]; then
    echo "$swapFile swap swap defaults 0 0" >> /etc/fstab
else
    echo "$swapFile is present in /etc/fstab file"
fi
