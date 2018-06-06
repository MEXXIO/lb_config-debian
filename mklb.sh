#!/bin/bash

cd $(dirname $0)
DATE=$(date +%Y%m%d)
DESKTOP=$(git branch | grep '*' | awk '{print $2}')
HOST_NAME=debian-"$DESKTOP"
PRESEED_CFG='config/includes.installer/preseed.cfg'

show_usage() {
	echo "Usage: sudo $(basename $0)"
	exit
}

root_or_gtfo() {
	[ $(id -u) = 0 ] || show_usage
}

fetch_packages() {
    [ -e config/packages.chroot/packages.chroot.list ] || return
    for PKG in $(cat config/packages.chroot/packages.chroot.list | grep -v '#')
    do
        FN=$(basename $PKG)
        if [ ! -e config/packages.chroot/$FN ]
        then
            wget -q $PKG -O config/packages.chroot/$FN
        fi
    done
}

lb_preseed() {
	cp -f config/includes.installer/preseed.template "$PRESEED_CFG"
	sed -i "s|HOSTNAME|$HOST_NAME|" "$PRESEED_CFG"
	sed -i "s|USERNAME|$SUDO_USER|" "$PRESEED_CFG"
}

lb_finish() {
	echo -e '\nDone!\n'
	mv live-image-amd64.hybrid.iso "$DESKTOP"-image-"$DATE".iso
	ls -lh "$DESKTOP"-image-"$DATE".iso
	rm -f "$PRESEED_CFG"
}

root_or_gtfo
fetch_packages

time (
	lb_preseed
	lb clean
	lb build
	lb_finish
)
