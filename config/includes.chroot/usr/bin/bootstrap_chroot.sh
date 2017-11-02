#!/bin/sh

CHROOT_DIR=/srv/chroot/sid
CHROOT_INCLUDES=
CHROOT_TARBALL=/srv/chroot/chroot-sid.tgz
HOST_DEPENDS="debootstrap schroot"

show_usage() {
	echo "Usage: sudo $(basename $0) [<base-packages.list>]"
	exit
}

root_or_gtfo() {
	[ $(id -u) = 0 ] || show_usage
}

check_arguments() {
	if [ ! -z $1 ]
	then
		if [ -e $1 ]
		then
			CHROOT_INCLUDES="--include=$(cat $1)"
		else
			show_usage
		fi
	fi
}

is_installed() {
	which $@ >/dev/null
	return $?
}

install_quietly() {
	apt install -qq --assume-yes $@
}

check_host_dependencies() {
	for DEP in $HOST_DEPENDS
	do
		is_installed $DEP || install_quietly $DEP
	done
}

do_debootstrap() {	
	debootstrap --arch=amd64 --variant=buildd "$CHROOT_DEPENDS" $@ sid $CHROOT_DIR
}

configure_schroot() {
	cp /etc/schroot/schroot.conf /etc/schroot/schroot.conf.orig
	cat > /etc/schroot/schroot.conf << EOF
[sid]
description=Debian sid (unstable)
directory=$CHROOT_DIR
users=$SUDO_USER
groups=sbuild
root-groups=root
aliases=unstable,default
EOF
}

setup_chroot() {
	if [ -e $CHROOT_DIR/.bootstrapped ]
	then
		echo "chroot already configured in $CHROOT_DIR"
		schroot -d / apt update
	else
		echo "setting up chroot in $CHROOT_DIR"
		mkdir -p $CHROOT_DIR

		if [ ! -e $CHROOT_TARBALL ]
		then
			do_debootstrap "--download-only --make-tarball=$CHROOT_TARBALL"
		fi
		do_debootstrap "--unpack-tarball=$CHROOT_TARBALL"

		touch $CHROOT_DIR/.bootstrapped
	fi

	schroot -l 2>/dev/null | fgrep -q 'chroot:sid' && \
		schroot -i 2>/dev/null | fgrep -q $CHROOT_DIR
	if [ $? != 0 ]
	then
		echo "configuring schroot"
		configure_schroot
	fi
}

root_or_gtfo
check_arguments $@
check_host_dependencies
setup_chroot
