#!/bin/bash

if (( $# != 2 )); then
    echo "Usage : convert_apk.sh <src.apk> <dst.apk>"
    exit
fi

src=$1
folder="unzipped_$src"
dst=$2


echo "unzipping into $folder (slow process)"
unzip -q -o $src -d $folder

echo "zipping back into $dst (slow process)"
zip -n "resources.arsc" -qr $dst $folder/*

echo "deleting $folder"
rm -rf $folder


echo 'done'