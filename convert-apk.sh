#!/bin/bash

# If < 1 arg, 2 args and no '-t' or > 3 args
if [ $# -lt 2 ] || [[ $# -eq 3 && $1 != '-t' ]] || [ $# -gt 3 ]; then
    echo "Usage : $0 [-t] <src.apk> <dst.apk>"
    echo '   -t : use tar instead of zip (no compression)'
    exit
fi

use_tar=0
if [ $1 == '-t' ]; then
    use_tar=1
    shift;
fi

src=$1
unzipped=$src.unzipped
dst=$2

if (( $use_tar )); then
	uncompress-resources.sh -t $src $unzipped
else
	uncompress-resources.sh $src $unzipped
fi
align-and-sign.bat $unzipped $dst