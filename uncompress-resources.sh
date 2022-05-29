#!/bin/bash

# Steps:
# 1) Give this file execution permission: `chmod +x uncompress-resources.sh`
# 2) Run the script with the right arguments

# And to have a fully installable apk (Android SDK tools needed):
# 3) If needed, create a key with:
#    `keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias`
# 4) Align the bytes of the newly created apk with:
#    `zipalign -v -p 4 my-app-unsigned.apk my-app-unsigned-aligned.apk`
# 5) Sign the aligned apk with:
#    `apksigner sign --ks my-release-key.jks --out my-app-release.apk my-app-unsigned-aligned.apk`

# More info on the official site:
# https://developer.android.com/studio/build/building-cmdline#sign_cmdline

# Original solution by T Aria:
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