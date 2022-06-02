#!/bin/bash

if [ $UID != 0 ]; then
	sudo $0
	exit
fi

#cat config/network-config > boot/network-config
cat config/user-data > boot/user-data
