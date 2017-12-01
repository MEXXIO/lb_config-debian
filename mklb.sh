#!/bin/bash

cd $(dirname $0)
DATE=$(date +%Y%m%d-%H:%M)
DESKTOP=$(git branch | awk '{print $2}')
HOST_NAME=debian-"$DESKTOP"
PRESEED_CFG='config/includes.installer/preseed.cfg'

show_usage() {
	echo "Usage: sudo $(basename $0)"
	exit
}

root_or_gtfo() {
	[ $(id -u) = 0 ] || show_usage
}

lb_preseed() {
	cp -f config/includes.installer/preseed.template "$PRESEED_CFG"
	sed -i "s|HOSTNAME|$HOST_NAME|" "$PRESEED_CFG"
	sed -i "s|USERNAME|$SUDO_USER|" "$PRESEED_CFG"
}

lb_finish() {
	mv live-image-amd64.hybrid.iso "$DESKTOP"-image-"$DATE".iso
	rm -f "$PRESEED_CFG"
}

root_or_gtfo
time (
	lb_preseed
	lb clean
	lb build
	lb_finish
)
