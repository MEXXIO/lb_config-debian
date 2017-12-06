#!/bin/sh

resolve_dependencies() {
	grep -q $@ $TMP/$PKG.list
	if [ $? != 0 ]
	then
		echo $@ >> $TMP/$PKG.list
		apt-cache depends $@ | grep ' .Depends: .*' | grep -v '<' | sed 's| .Depends: ||' > $TMP/$@.depends
		if [ -s $TMP/$@.depends ]
		then
			return 1
		else
			rm -f $TMP/$@.depends
		fi
	fi
	return 0
}

resolve_recursively() {
	while true
	do
		CNT=$(ls -l $TMP | grep '.depends' | wc -l)
		if [ $CNT -gt 0 ]
		then
			for LIST in $TMP/*.depends
			do
				for DEP in $(cat $LIST)
				do
					resolve_dependencies $DEP
				done
				rm -f $LIST
			done
		else
			cat $TMP/$PKG.list | sort > $PKG.list
			break
		fi
	done
}

if [ -z $1 ]
then
	echo "Usage: $(basename $0) <packageName>"
	exit
fi

PKG=$1
TMP=/tmp/depends
rm -rf $TMP
mkdir -p $TMP
> $TMP/$PKG.list

resolve_dependencies $PKG
if [ $? = 0 ]
then
	echo "$PKG has no dependencies"
else
	resolve_recursively
	TOTAL=$(wc -l $PKG.list | awk '{print $1}')
	echo "$PKG has $TOTAL packages in its tree of dependencies"
fi
rm -rf $TMP