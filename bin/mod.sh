#!/bin/bash

ROOT=./fs/
sudo touch $ROOT/etc/cloud/cloud-init.disabled
sudo mv $ROOT/lib/udev/rules.d/80-net-setup-link.rules $ROOT/lib/udev/rules.d/80-net-setup-link.rules.bak
sudo ln -s /dev/null $ROOT/lib/udev/rules.d/80-net-setup-link.rules
sudo sh -c 'echo "options mt76_usb disable_usb_sg=1" > $ROOT/etc/modprobe.d/mt76_usb.conf'

# disable dhclient on the WANIF, since we will run our own dhcp
#sudo sh -c 'echo "network: {config: disabled}" > $ROOT/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg'

sudo cp spr-install.sh fs/
sudo cp config/network-config boot/
sudo cp config/user-data boot/
