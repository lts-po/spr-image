#!/bin/bash

if [ $UID != 0 ]; then
	sudo $0
	exit
fi

ROOT=./fs/

touch $ROOT/etc/cloud/cloud-init.disabled
mv $ROOT/lib/udev/rules.d/80-net-setup-link.rules $ROOT/lib/udev/rules.d/80-net-setup-link.rules.bak
ln -s /dev/null $ROOT/lib/udev/rules.d/80-net-setup-link.rules
echo "options mt76_usb disable_usb_sg=1" > $ROOT/etc/modprobe.d/mt76_usb.conf

# disable dhclient on the WANIF, since we will run our own dhcp
#sh -c 'echo "network: {config: disabled}" > $ROOT/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg'

cp spr-install.sh fs/
cp config/network-config boot/
cp config/user-data boot/
