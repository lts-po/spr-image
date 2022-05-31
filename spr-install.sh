#!/bin/bash

if [ $UID != 0 ]; then
	sudo $0
	exit
fi

echo "[+] installing dependencies..."

apt-get update
apt-get -y install docker.io docker-compose nftables linux-modules-extra-raspi

# disable resolved
systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm /etc/resolv.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

# disable iptables for docker
echo "{\n  \"iptables\": false\n}" > /etc/docker/daemon.json

echo "[+] fetching SPR..."

# SPR setup
mkdir /home/spr
cd /home/spr
git clone https://github.com/spr-networks/super
cd super

# generate basic configs
cp -R base/template_configs configs

INTERFACE="wlan0"
PASSWORD="SPRchangemE"

cat configs/base/config.sh | sed "s/SSID_INTERFACE=wlan1/SSID_INTERFACE=$INTERFACE/g"
echo "{\"admin\" : \"${PASSWORD}\"}" > configs/base/auth_users.json

./configs/scripts/gen_coredhcp_yaml.sh > configs/dhcp/coredhcp.yml
./configs/scripts/gen_hostapd.sh > configs/wifi/hostapd.conf
./configs/scripts/gen_watchdog.sh  > configs/watchdog/watchdog.conf

# when booted run this
#./run_prebuilt.sh
