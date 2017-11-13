#!/bin/sh

THINGS=".cache
.config
.dmrc
.gitconfig
.gnome
.gnupg
.ICEauthority
.local
.nano
.pki
.ssh
.thumbnails
.Xauthority
.xfce4-session.verbose-log
.xfce4-session.verbose-log.last
.xsession-errors
.xsession-errors.old"

for STUFF in $THINGS
do
	rm -rf ~/$STUFF
done

sudo shutdown -r now
