#!/bin/bash

if [ $UID != 0 ]; then
	sudo $0
	exit
fi

ROOT=./fs/

# NOTE cloud-init is used for initial boot to login as ubuntu:ubuntu

#touch $ROOT/etc/cloud/cloud-init.disabled
#mv $ROOT/lib/udev/rules.d/80-net-setup-link.rules $ROOT/lib/udev/rules.d/80-net-setup-link.rules.bak
#ln -s /dev/null $ROOT/lib/udev/rules.d/80-net-setup-link.rules

echo "options mt76_usb disable_usb_sg=1" > $ROOT/etc/modprobe.d/mt76_usb.conf
echo -en "[Match]\nDriver=mt76x2u\n\n[Link]\nName=wlan1" > $ROOT/usr/lib/systemd/network/10-raspi-wifi.link

# disable dhclient on the WANIF, since we will run our own dhcp
#sh -c 'echo "network: {config: disabled}" > $ROOT/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg'

# modify fs
cp spr-install.sh $ROOT/
chown root:root $ROOT/spr-install.sh
chmod 755 $ROOT/spr-install.sh

# modify boot partition - cloud init
#cp config/network-config boot/
#cp config/user-data boot/
#chown root:root ./boot/{network-config,user-data}
#chmod 755 ./boot/{network-config,user-data}
