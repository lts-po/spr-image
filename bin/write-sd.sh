#!/bin/bash

sudo umount boot 2>/dev/null
sudo umount fs 2>/dev/null

IMG=./data/spr.img
#TODO hardcoded sd
OF=/dev/mmcblk0

if [ ! -f $IMG ]; then
	echo "- missing ${IMG}. exiting"
	exit
fi

echo "[+] writing SPR to ${OF}..."
sudo dd if=$IMG of=$OF bs=32M status=progress
