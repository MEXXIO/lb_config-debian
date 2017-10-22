#!/bin/bash

resolve_dependencies() {
	grep -q $@ .deptmp/$PKG.list
	if [ $? != 0 ]
	then
		echo $@ >> .deptmp/$PKG.list
		apt-cache depends $@ | grep ' .Depends: .*' | grep -v '<' | sed 's| .Depends: ||' | sort > .deptmp/$@.depends
		if [ -s .deptmp/$@.depends ]
		then
			return 1
		else
			rm -f .deptmp/$@.depends
		fi
	fi
	return 0
}

resolve_recursively() {
	while true
	do
		CNT=$(ls -l .deptmp/ | grep '.depends' | wc -l)
		if [ $CNT -gt 0 ]
		then
			for LIST in .deptmp/*.depends
			do
				for DEP in $(cat $LIST)
				do
					resolve_dependencies $DEP
				done
				rm -f $LIST
			done
		else
			cat .deptmp/$PKG.list | sort > $PKG.list
			rm -rf .deptmp
			break
		fi
	done
}

if [ -z $1 ]
then
	echo -e "Usage: $(basename $0) packageName\n"
	exit
fi

PKG=$1
rm -rf .deptmp
mkdir -p .deptmp
> .deptmp/$PKG.list

resolve_dependencies $PKG
if [ $? == 0 ]
then
	echo "$PKG has no dependencies"
else
	resolve_recursively
	TOTAL=$(cat $PKG.list | wc -l)
	echo "$PKG has $TOTAL packages in its tree of dependencies"
fi
