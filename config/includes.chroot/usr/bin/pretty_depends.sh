#!/bin/bash

apt_grep() {
	echo "$@"
	echo "    Depends On:"
	apt-cache depends $@ | grep -v '<' | grep -v '>' | grep ' .Depends: .*' | sed 's/ .Depends: /        /' | sort | uniq
	echo
	echo "    Recommends:"
	apt-cache depends $@ | grep -v '<' | grep -v '>' | grep ' .Recommends: .*' | sed 's/ .Recommends: /        /' | sort | uniq
	echo
}

for arg in $@
do
	apt_grep $arg
done

