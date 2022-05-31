#!/bin/bash

IMAGE_BASE="spr:base"

IMG="./data/spr.img"
export LOOP=$(losetup -j $IMG | cut -d: -f1)
export LOOP_ROOT="${LOOP}p2"
export LOOP_BOOT="${LOOP}p1"
echo "$LOOP" | grep /dev
if [ $? -gt 0 ] ; then
	echo "- $IMG is not mounted"
	./bin/mount-img.sh
fi

sudo -E mount $LOOP_ROOT ./fs
sudo tar -cf root.tar -C ./fs .
sudo chown ubuntu:ubuntu ./root.tar
docker import ./root.tar $IMAGE_BASE

echo "+ ${IMAGE_BASE} imported to docker"

# cleanup
rm -f root.tar
