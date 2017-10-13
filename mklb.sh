#!/bin/bash

cd $(dirname $0)

[ -d .local ] || mkdir -p .local

if [ -e .local/lb.cfg ] && [ -e config/includes.installer/preseed.template ]; then
	source .local/lb.cfg
	cp -f config/includes.installer/preseed.template config/includes.installer/preseed.cfg

	[ -n "$PRESEED_HOSTNAME" ] && sed -i "s|HOSTNAME|$PRESEED_HOSTNAME|" config/includes.installer/preseed.cfg
	[ -n "$PRESEED_USERNAME" ] && sed -i "s|USERNAME|$PRESEED_USERNAME|" config/includes.installer/preseed.cfg
	[ -n "$PRESEED_USERFULLNAME" ] && sed -i "s|USERFULLNAME|$PRESEED_USERFULLNAME|" config/includes.installer/preseed.cfg
	[ -n "$PRESEED_USERPASSWORD" ] && sed -i "s|USERPASSWORD|$PRESEED_USERPASSWORD|" config/includes.installer/preseed.cfg

	unset PRESEED_HOSTNAME PRESEED_USERNAME PRESEED_USERFULLNAME PRESEED_USERPASSWORD
	PRESEEDED=true
fi

if [ $# == 0 ]; then ARGS="clean config bootstrap chroot installer binary" ; else ARGS="$@" ; fi

for ARG in $ARGS ; do lb $ARG ; done

[ $PRESEEDED ] && rm -f config/includes.installer/preseed.cfg
