#!/bin/bash

ARCH=amd64
OPTIONS=
SUITE=sid
ALIAS=unstable
TARGET=/srv/chroot/$SUITE
TARBALL=/srv/chroot/chroot-$SUITE.tgz
MIRROR=http://ftp.us.debian.org/debian/
DEPENDS="debootstrap schroot"

show_usage() {
	echo "Usage: sudo $(basename $0) [<base-packages.list>]"
	exit
}

root_or_gtfo() {
	[ $(id -u) = 0 ] || show_usage
}

check_arguments() {
	case $# in
		0)
			return
			;;
		1)
			if [ -e $1 ]
			then
				OPTIONS="--include=$(cat $1)"
				return
			fi
			;;
		*)
			;;
	esac
	show_usage
}

is_installed() {
	which $@ >/dev/null
	return $?
}

install_quietly() {
	apt install -qq --assume-yes $@
}

check_host_dependencies() {
	for DEP in $DEPENDS
	do
		is_installed $DEP || install_quietly $DEP
	done
}

do_debootstrap() {
	debootstrap --arch=$ARCH \
		--variant=buildd \
		$OPTIONS \
		$@ \
		$SUITE \
		$TARGET \
		$MIRROR
}

configure_schroot() {
	cp /etc/schroot/schroot.conf /etc/schroot/schroot.conf.orig
	cat > /etc/schroot/schroot.conf << EOF
[$SUITE]
description=Debian $SUITE ($ALIAS)
directory=$TARGET
users=$SUDO_USER
groups=sbuild
root-groups=root
aliases=$ALIAS,default
EOF
}

setup_chroot() {
	if [ -e $TARGET/.bootstrapped ]
	then
		echo "A chroot environment is already configured in $TARGET"
	else
		echo "Setting up chroot in $TARGET"
		mkdir -p $TARGET

		if [ ! -e $TARBALL ]
		then
			do_debootstrap "--download-only --make-tarball=$TARBALL"
		fi
		do_debootstrap "--unpack-tarball=$TARBALL"

		touch $TARGET/.bootstrapped
	fi

	schroot -l 2>/dev/null | fgrep -q "chroot:$SUITE" && \
		schroot -i 2>/dev/null | fgrep -q $TARGET
	if [ $? != 0 ]
	then
		echo "Configuring schroot"
		configure_schroot
	fi

	schroot -d / apt update
	schroot -d / apt upgrade
}

root_or_gtfo
time (
	check_arguments $@
	check_host_dependencies
	setup_chroot
)
