#!/bin/sh

THINGS=".cache
.config
.gnome
.gnupg
.ICEauthority
.local
.nano
.pki
.Xauthority
.xfce4-*
.xsession-*"

cd ~/
for STUFF in $THINGS
do
	rm -rf $STUFF
done

