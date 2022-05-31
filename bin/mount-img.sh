#!/bin/bash

IMG="./data/spr.img"

if [ ! -f $IMG ]; then
	echo "- missing image"
	exit
fi

if [ $UID != 0 ]; then
	sudo $0
	exit
fi

losetup -Pf $IMG

export LOOP=$(losetup -j $IMG | cut -d: -f1)
export LOOP_ROOT="${LOOP}p2"
export LOOP_BOOT="${LOOP}p1"

echo "+ loop is $LOOP"
echo "+ boot is $LOOP_BOOT"
echo "+ root is $LOOP_ROOT"

mkdir boot 2>/dev/null
mkdir fs 2>/dev/null
sudo mount $LOOP_BOOT ./boot
sudo mount $LOOP_ROOT ./fs
