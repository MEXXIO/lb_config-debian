#!/bin/bash

[ $(id -u) = 0 ] || exit

COUNT=$(apt update -qq 2>/dev/null | grep -v All | awk '{print $1}')

if [ ! -z $COUNT ] && [ $COUNT -ge 1 ]
then
    [ $COUNT -gt 1 ] && S="s"
    printf "Upgrading $COUNT package$S.\n"
    apt dist-upgrade -qqy
else
    printf "All packages are up to date.\n"
fi
