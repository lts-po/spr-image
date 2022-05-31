#!/bin/bash

VERSION="22.04"
IMG="ubuntu-${VERSION}-preinstalled-server-arm64+raspi.img.xz"

cd ./data
wget "https://cdimage.ubuntu.com/releases/${VERSION}/release/${IMG}"
#wget "https://cdimage.ubuntu.com/releases/21.10/release/ubuntu-21.10-preinstalled-server-arm64+raspi.img.xz"

xzcat $IMG > spr.img
