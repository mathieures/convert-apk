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
compress_with_tar()
{
    dst_zip="$dst.zip"
    # tar -C does not work on Git Bash so we have to cd
    pushd $unzipped >/dev/null
    tar -P -acf $dst_zip --options compression-level=0 *
    # Move the zip file outside
    wd=$(pwd)
    popd >/dev/null
    # Move and rename the file
    mv "$wd/$dst_zip" $dst
}

compress_with_zip()
{
    zip -n "resources.arsc" -qr $dst $unzipped/*
}


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
unzipped="$src.unzipped"
dst=$2


echo "Unzipping into $unzipped"
unzip -q -o $src -d $unzipped

echo "Zipping back into $dst"
if (( $use_tar )); then
    echo ' using tar'
    compress_with_tar
else
    echo ' using zip'
    compress_with_zip
    if [ $? ]; then
        echo '[fatal] zip command not found; consider running with -t flag'
        exit 1
    fi
    # if [ compress_with_zip ]; then
    #     echo '[fatal] zip command not found; consider running with -t flag'
    #     exit 1
    # fi
fi

echo "Deleting $unzipped"
rm -rf $unzipped


echo 'Done'
