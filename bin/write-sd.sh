#!/bin/bash

sudo umount boot 2>/dev/null
sudo umount fs 2>/dev/null

IMG=./data/spr.img
OF=/dev/mmcblk0

echo "[+] writing SPR to ${OF}..."
sudo dd if=$IMG of=$OF bs=32M status=progress
