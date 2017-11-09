#!/bin/sh

echo
[ "$#" != 2 ] && echo -e "Usage: $(basename $0) \"user.email\" \"user.name\"\n" && exit
[ -e ~/.ssh/id_rsa.pub ] && echo "There is already a public key installed" && exit

echo -e "user.email = $1"
echo -e "user.name  = $2\n"
echo -e "Is this correct?\n"
echo -e "Enter 'y' or 'n'\n"
read answer
echo
if [ "$answer" != "y" ]; then
    echo -e "Exiting...\n"
    exit
fi

echo -e "Running git config\n"
git config --global user.email "$1"
git config --global user.name "$2"
echo

echo -e "Creating new ssh key\n"
ssh-keygen -t rsa -b 4096 -C "$1"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo

xclip -sel clip < ~/.ssh/id_rsa.pub
echo -e "New ssh key has been copied to the clipboard\n"
