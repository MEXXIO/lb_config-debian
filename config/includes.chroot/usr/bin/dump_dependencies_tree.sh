#!/bin/bash
resolve_dependencies() {
	grep -q $@ .tmp/$PKG.list
	if [ $? != 0 ]
	then
		echo $@ >> .tmp/$PKG.list
		apt-cache depends $@ | fgrep -v '<' | grep ' .Depends: .*' | sed 's| .Depends: ||' | sort > .tmp/$@.depends
		if [ -s .tmp/$@.depends ]
		then
			return 1	# more deps needed to process
		else
			rm -f .tmp/$@.depends	# don't process; no deps
		fi
	fi
	return 0
}
resolve_recursively() {
	while true
	do
		CNT=$(ls -l .tmp/ | fgrep '.depends' | wc -l)
		if [ $CNT -gt 0 ]
		then
			for LIST in .tmp/*.depends
			do
				for DEP in $(cat $LIST)
				do
					resolve_dependencies $DEP
				done
				rm -f $LIST
			done
		else
			cat .tmp/$PKG.list | sort > $PKG.list
			rm -rf .tmp
			break
		fi
	done
}

if [ -z $1 ]
then
	echo "Specify the name of a package"
	exit
fi

PKG=$1
rm -rf .tmp
mkdir -p .tmp
> .tmp/$PKG.list

resolve_dependencies $PKG
if [ $? == 0 ]	# PKG has no dependencies
then
	echo "$PKG has no dependencies"
else
	resolve_recursively
	TOTAL=$(cat $PKG.list | wc -l)
	echo "$PKG has $TOTAL packages in its tree of dependencies"
fi
