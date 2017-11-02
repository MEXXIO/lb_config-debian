#!/bin/bash

cd $(dirname $0)
PRESEED_CFG='config/includes.installer/preseed.cfg'

preseed_config() {
	source .local/lb.cfg
	[ -n "$PRESEED_HOSTNAME" ] && [ -n "$PRESEED_USERNAME" ] &&
		[ -n "$PRESEED_USERFULLNAME" ] && [ -n "$PRESEED_USERPASSWORD" ] &&
			cp -f config/includes.installer/preseed.template "$PRESEED_CFG" || return

	sed -i "s|HOSTNAME|$PRESEED_HOSTNAME|" "$PRESEED_CFG"
	sed -i "s|USERNAME|$PRESEED_USERNAME|" "$PRESEED_CFG"
	sed -i "s|USERFULLNAME|$PRESEED_USERFULLNAME|" "$PRESEED_CFG"
	sed -i "s|USERPASSWORD|$PRESEED_USERPASSWORD|" "$PRESEED_CFG"
}
[ -e .local/lb.cfg ] && preseed_config

lb clean
lb config
lb bootstrap
#./mate/mkmate.sh
lb chroot
lb installer
lb binary

rm -f "$PRESEED_CFG"
