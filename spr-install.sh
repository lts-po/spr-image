#!/bin/bash

if [ $UID != 0 ]; then
	sudo $0
	exit
fi

echo "[+] installing dependencies..."

# NOTE could already be installed by cloud init package install
apt-get update
apt-get -y install docker.io docker-compose nftables linux-modules-extra-raspi

modprobe mt76x2u

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

# config wizard starts here

# generate basic configs
cp -R base/template_configs configs

#TODO
CONFIG_FILE="configs/base/config.sh"
AUTH_FILE="configs/base/auth_users.json"
#CONFIG_FILE="sample"
#AUTH_FILE="auth_users.json"

IFACE_DEFAULT="wlan1"
IFACE_WAN_DEFAULT="eth0"
SSID_DEFAULT="TestLab"

echo -ne "  wifi card for spr[${IFACE_DEFAULT}]: "
read IFACE
if [ -z $IFACE ]; then
	IFACE=$IFACE_DEFAULT
fi

echo -ne "  upstream wan interface [${IFACE_WAN_DEFAULT}]: "
read IFACE_WAN
if [ -z $IFACE_WAN ]; then
	IFACE_WAN=$IFACE_WAN_DEFAULT
fi

sed -i "s/SSID_INTERFACE=.*/SSID_INTERFACE=${IFACE}/g" $CONFIG_FILE

echo -ne "  wifi ssid [${SSID_DEFAULT}]: "
read SSID
if [ -z $SSID ]; then
	SSID=$SSID_DEFAULT
fi

sed -i "s/SSID_NAME=.*/SSID_NAME=${SSID}/g" $CONFIG_FILE

echo -ne "  admin password for api [generate]: "
read PASSWORD
if [ -z $PASSWORD ]; then
	PASSWORD=$(tr -dc _A-Z-a-z-0-9 < /dev/urandom | head -c${1:-8})
fi

USER="admin"
echo -ne "{\"${USER}\" : \"${PASSWORD}\"}" > $AUTH_FILE

echo -ne "  enable access to ssh & http api on $IFACE_WAN [yes]: "
read ENABLE_UPSTREAM

if [ -z "$ENABLE_UPSTREAM" ] || [ "$ENABLE_UPSTREAM" == "yes" ]; then
	# NOTE already set by default in template config
	sed -i "s/^#UPSTREAM_SERVICES_ENABLE=.*/UPSTREAM_SERVICES_ENABLE=1/g" $CONFIG_FILE
else
	sed -i "s/^UPSTREAM_SERVICES_ENABLE=.*/#UPSTREAM_SERVICES_ENABLE=1/g" $CONFIG_FILE
fi


exit
echo -ne "  start spr[yes]: "
read START

if [ "$START" != "no" ]; then
	echo "+ starting spr..."

	./configs/scripts/gen_coredhcp_yaml.sh > configs/dhcp/coredhcp.yml
	./configs/scripts/gen_hostapd.sh > configs/wifi/hostapd.conf
	./configs/scripts/gen_watchdog.sh  > configs/watchdog/watchdog.conf

	./run_prebuilt.sh
fi

IP_WAN=$(ip addr|grep "dynamic ${IFACE_WAN}" | head -1 | awk '{print $2}' | sed 's/\/.*//g')
IP_SPR=$(ip addr|grep "global ${IFACE}" | head -1 | awk '{print $2}' | sed 's/\/.*//g')
#IP_SPR="192.168.2.1"

echo "+ done!"
echo "+ login on http://${IP_WAN} or http://${IP_SPR} if connected to ${SSID}"
echo "  using ${USER} : ${PASSWORD}"
