#!/bin/bash

if (( $# != 2 )); then
    echo "Usage : $0 <src.apk> <dst.apk>"
    exit
fi

src=$1
temp=temp_$dst
dst=$2

keyname=temp_key.jks


echo "creating key; you can enter dummy credentials"
keytool -genkey -v -keystore $keyname -keyalg RSA -keysize 2048 -validity 10000

# TODO: fill info automatically

echo "aligning $src into $temp"
zipalign -v -p 4 $src $temp

echo "signing $temp into $dst"
apksigner sign --ks $keyname --out $dst $temp

# echo "deleting key and $temp"
# rm -f $keyname
# rm -f $temp


echo 'done'