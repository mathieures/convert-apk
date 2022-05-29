#!/bin/bash

# After running this script, you will need to zipalign and sign the apk yourself:
# https://developer.android.com/studio/build/building-cmdline#sign_cmdline

# Original solution and more details in this StackOverflow's answer:
# https://stackoverflow.com/a/69893912

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