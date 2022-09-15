#!/bin/bash

# Stop the program if any error occurs
set -e

# If < 1 arg, 2 args and no '-t' or > 3 args
if [ $# -lt 2 ] || [[ $# -eq 3 && $1 != '-t' ]] || [ $# -gt 3 ]; then
    echo "Usage : $0 [-t] <src.apk> <dst.apk>"
    echo '   -t : use tar instead of zip (no compression)'
    exit
fi

use_tar=0
if [ "$1" == '-t' ]; then
    use_tar=1
    shift;
fi

src=$1
unaligned_unsigned=$src.zip
dst=$2
dir=$(dirname $0)

if [ $use_tar -ne 0 ]; then
	$dir/uncompress-resources.sh -t "$src" "$unaligned_unsigned"
else
	$dir/uncompress-resources.sh "$src" "$unaligned_unsigned"
fi
$dir/align-and-sign.sh "$unaligned_unsigned" "$dst"