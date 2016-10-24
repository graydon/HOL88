#!/bin/sh
#
# Copyright 1991 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
# set -x
LIB=|LIBDIR|
opt= arg= markopt=
for i do
	case $i in
        -ml|-m3|-awk|-c|-w[0-9][0-9]*) ;; # deliberately ignore nountangle args
	-t)  ;; # this is default
        -t*) markopt="$markopt -t" ; opt="$opt '$i'" ;;
		# copy tabs at markup, use width given in notangle
	-)   arg="$arg '$i'" ;;
	-*)  opt="$opt '$i'" ;;
	*)   arg="$arg '$i'" ;;
	esac
done
eval "$LIB/markup $markopt $arg | $LIB/nt $opt"
