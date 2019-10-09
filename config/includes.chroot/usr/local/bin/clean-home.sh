#!/bin/sh

THINGS=".airvpn
.android
.bash_history
.cache
.config
.dmrc
.equake_appletrc
.equake_sigfile.eq
.gconf
.gitconfig
.gnome
.gnupg
.googleearth
.ICEauthority
.kde
.lesshst
.local
.mozilla
.nano
.pki
.ssh
.thumbnails
.wget-hsts
.Xauthority
.xfce4-session.verbose-log
.xfce4-session.verbose-log.last
.xscreensaver
.xsession-errors
.xsession-errors.old"

for STUFF in $THINGS
do
	rm -rf ~/$STUFF
done

sudo shutdown -r now
