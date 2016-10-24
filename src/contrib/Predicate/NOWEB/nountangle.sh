#!/bin/sh
#
# Copyright 1991 by Norman Ramsey.  All rights reserved.
# See file COPYRIGHT for more information.
# set -x
LIB=|LIBDIR|
opt= 
arg=

width=72
subst='gsub("\\*/", "* /", s)'
format='/* %%-%ds */'

for i do
        case $i in
        -ml|-m3) format='(* %%-%ds *)' ; subst='gsub("\\*\\)", "* )", s)' ;;
        -awk)    format='# %%%ds' ;      subst=' ' ;;
        -c)      format='/* %%-%ds */'   subst='gsub("\\*/", "* /", s)' ;;
	-pascal) format='{ %%-%ds }' ;   subst='gsub("[{}]", "-", s)' ;;
        -L*) ;; # deliberately ignore requests for #line
        -w[0-9][0-9]*)    width=`echo $i | sed 's/^-w//'` ;;
	-)  arg="$arg '$i'" ;;
        -*) opt="$opt '$i'" ;;
        *)  arg="$arg '$i'" ;;
        esac
done

eval "$LIB/markup $arg" |
nawk 'BEGIN { line = 0; capture = 0; format=sprintf("'"$format"'",'"$width"') }

function comment(s) {
    '"$subst"'
    return sprintf(format,s)
}

function grab(s) {
  if (capture==0) print
  else holding[line] = holding[line] s
}
   
/^@end doc/ { capture = 0; holding[++line] = "" ; next }
/^@begin doc/ { capture = 1; next }

/^@text /     { grab(substr($0,7)); next}
/^@quote$/    { grab("[[") ; next}
/^@endquote$/ { grab("]]") ; next}

/^@nl$/ { if (capture !=0 ) {
            holding[++line] = ""
          } else if (defn_pending != 0) {
	    print "@nl"
            for (i=0; i<=line && holding[i] ~ /^ *$/; i++) i=i
            for (; i<=line; i++) printf "@text %s\n@nl\n", comment(holding[i])
            line = 0; holding[0] = ""
            defn_pending = 0
          } else print
          next  
        }

/^@defn / { holding[line] = holding[line] "<"substr($0,7)">=" # (line should be blank)
            print ; defn_pending = 1 ; next }
{ print }' |
eval "$LIB/nt $opt"
