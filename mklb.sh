#!/bin/sh

cd $(dirname $0)
DATE=$(date +%F)
DESKTOP=$(git branch | awk '{print $2}')
PRESEED_CFG='config/includes.installer/preseed.cfg'

lb_preseed() {
	[ -e .local/lb.cfg ] && . .local/lb.cfg
	[ -n "$PRESEED_HOSTNAME" ] && [ -n "$PRESEED_USERNAME" ] &&
		[ -n "$PRESEED_USERFULLNAME" ] && [ -n "$PRESEED_USERPASSWORD" ] &&
			cp -f config/includes.installer/preseed.template "$PRESEED_CFG" || return

	sed -i "s|HOSTNAME|$PRESEED_HOSTNAME|" "$PRESEED_CFG"
	sed -i "s|USERNAME|$PRESEED_USERNAME|" "$PRESEED_CFG"
	sed -i "s|USERFULLNAME|$PRESEED_USERFULLNAME|" "$PRESEED_CFG"
	sed -i "s|USERPASSWORD|$PRESEED_USERPASSWORD|" "$PRESEED_CFG"
}

lb_preseed
lb clean
lb build

mv live-image-amd64.hybrid.iso "$DESKTOP"-image-"$DATE".iso
rm -f "$PRESEED_CFG"
