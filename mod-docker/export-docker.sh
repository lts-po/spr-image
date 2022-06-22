#!/bin/bash

# make sure the fs image is mounted
IMG="./data/spr.img"
export LOOP=$(losetup -j $IMG | cut -d: -f1)
export LOOP_ROOT="${LOOP}p2"
export LOOP_BOOT="${LOOP}p1"
echo "$LOOP" | grep /dev
if [ $? -gt 0 ] ; then
	echo "- $IMG is not mounted"
	./bin/mount-img.sh
fi

IMAGE="spr:image"
CONTAINER=$(docker run -d $IMAGE bash)
docker export $CONTAINER > custom-root.tar

docker stop $CONTAINER && docker rm $CONTAINER

echo "+ ${CONTAINER} exported to custom-root.tar"


echo "+ writing to ${LOOP_ROOT}..."

# make parts is not mounted
sudo umount ./boot 2>/dev/null
#sudo umount ./fs 2>/dev/null
#sudo -E mkfs.ext4 -F $LOOP_ROOT
#sudo -E mount $LOOP_ROOT ./fs

sudo tar xf ./custom-root.tar -C ./fs

# cleanup
rm -f ./custom-root.tar

# unmount
sudo umount ./fs
sudo losetup -d $LOOP

echo "+ all done, $IMG is ready"
ls -lsh $IMG
