FROM spr:base

# set environment variables so apt installs packages non-interactively
# these variables will only be set in Docker, not in the resultant image
ENV DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical

RUN apt-get update
#RUN apt-get -y upgrade

# this is base/setup.sh
RUN apt-get -y install docker.io docker-compose nftables linux-modules-extra-raspi

RUN touch /etc/cloud/cloud-init.disabled
# delete obsolete packages and any temporary state
RUN mv /lib/udev/rules.d/80-net-setup-link.rules /lib/udev/rules.d/80-net-setup-link.rules.bak
RUN ln -s /dev/null  /lib/udev/rules.d/80-net-setup-link.rules

# Add a bug fix for scatter/gather bugs with USB:
RUN echo "options mt76_usb disable_usb_sg=1" > /etc/modprobe.d/mt76_usb.conf

# do not use systemd-resolvd, we will use our own container later
RUN systemctl disable systemd-resolved
#RUN rm -f /etc/resolv.conf
RUN echo "nameserver 1.1.1.1" > /etc/resolv.conf

# disable dhclient on the WANIF, since we will run our own dhcp
#RUN echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

# disable iptables for  docker
RUN echo "{\n  \"iptables\": false\n}" > /etc/docker/daemon.json

# TODO fetch spr && config

# cleanup
RUN apt-get autoremove -y && apt-get clean
RUN rm -rf \
    /tmp/* \
    /var/backups/* \
    /var/log/* \
    /var/run/* \
    /var/crash/* \
    /var/lib/apt/lists/* \
    ~/.bash_history
