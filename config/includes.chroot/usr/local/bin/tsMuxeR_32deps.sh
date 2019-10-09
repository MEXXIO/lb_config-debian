#!/bin/bash

# install 32 bit libraries needed for tsMuxeR

[ $(id -u) = 0 ] || (echo "You need to be root"; exit)

dpkg --add-architecture i386
apt update -qq

apt install -y lib32z1 lib32ncurses6 libbz2-1.0:i386 libfreetype6:i386 libstdc++6:i386
