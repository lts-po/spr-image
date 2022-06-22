# SPR Image

Build custom SPR image for raspi/arm64

**IMPORTANT**
`write-sd.sh` will write to */dev/mmcblk0*.
If you are writing to a usb or other device you need to change this before running `build.sh` or ` write-sd.sh`!
**IMPORTANT**

## Build

```sh
./bin/build.sh
```

or run them individually:

```sh
./bin/download-img.sh
./bin/mount-img.sh
./bin/mod.sh
./bin/write-sd.sh
```

## Download

download ubuntu here:
https://ubuntu.com/download/raspberry-pi/thank-you?version=21.10&architecture=server-arm64+raspi
https://ubuntu.com/download/raspberry-pi/thank-you?version=22.04&architecture=server-arm64+raspi

or use ./bin/download-img.sh



## current state

we modify /etc and other things to run ok. todo:
	* install packages
	* disabled systemd-resolved
	* FULL image: add spr and install everything
		- setup in webui or .sh

this is the default mode where we have uplink on eth0 and use wlan0
--> so have two images:
	* spr [config wizard + pull spr from install script]
	* sprpi [eth0 + wlan0 + spr in image]

## random notes

have a init.sh as entry when running the container
that runs git clone spr
better to have this here - dont have to build the main image every time there is a update

## TODO - Note on network config

```sh
mkdir boot
sudo mount $LOOP_BOOT ./boot
sudo cp network-config boot/network-config
sudo umount ./boot
rm -rf boot
```

content:
```yaml
version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
wifis:
  wlan0:
    dhcp4: true
    optional: true
    access-points:
      myhomewifi:
        password: "S3kr1t"
```

## Modify image using docker
```sh
export IMG=ubuntu-22.04-preinstalled-server-arm64+raspi.img
export IMG_SPR=spr-arm64+raspi.img

unxz $IMG.xz
sudo -E losetup -Pf $IMG
sudo -E losetup -j $IMG
mkdir fs

#TODO parse loop dev here.
export LOOP=/dev/loop6
export LOOP_ROOT="${LOOP}p2"
export LOOP_BOOT="${LOOP}p1"

sudo mount $LOOP_ROOT ./fs
sudo tar -cf root.tar -C ./fs .
sudo chown ubuntu:ubuntu ./root.tar
docker import ./root.tar spr:base
```

export image when modified
```sh
CONTAINER=$(docker run -d spr:image bash)
docker export $CONTAINER > custom-root.tar

sudo -E mkfs.ext4 -F $LOOP_ROOT
sudo -E mount $LOOP_ROOT ./fs
sudo tar xf ./custom-root.tar -C ./fs
sudo umount ./fs
sudo losetup -d $LOOP
sudo -E mv $IMG $IMG_SPR

#TODO cleanup
```

```sh
xzcat ubuntu-22.0-4-preinstalled-server-arm64+raspi.img.xz | dd of=/dev/rdisk2 bs=$[1024*1024]
dd if=ubuntu-22.0-4-preinstalled-server-arm64+raspi.img of=/dev/rdisk2 bs=$[1024*1024]
```
