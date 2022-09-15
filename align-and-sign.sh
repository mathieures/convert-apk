#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage : $0 <src.apk> <dst.apk>"
    exit
fi

src=$1
aligned_apk=$src.aligned
dst=$2
signing_details="$dst".idsig

# Change these if you use a custom key
key=/tmp/signing_key
password=password

# Files with dummy credentials in case of a new key
dummycred=/tmp/dummy_cred


echo "Aligning $src into $aligned_apk"
# If the file exists, remove it
if [ -a "$aligned_apk" ]; then
    rm -r "$aligned_apk"
fi
zipalign -p 4 "$src" "$aligned_apk"

# If the file exists
if [ -a $key ]; then
    echo "Using existing key $key"
else
    echo 'Creating key'
    # Newlines to pass the prompts
     >$dummycred echo "$password"
    >>$dummycred echo "$password"
    >>$dummycred echo -ne "\n\n\n\n\n\n"

    # First letter of 'yes' in English, French, Spanish and German.
    # Feel free to change letters if these don't work
    yes_chars=(y o s j)

    # Try to create a key with the character until it works
    for yes_char in ${yes_chars[*]}; do
        echo " testing with '$yes_char' as 'yes'..."
        >> $dummycred echo $yes_char

        cat $dummycred | keytool -genkey -keystore $key -keyalg RSA -keysize 2048 -validity 10000 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo ' fail'
            # Delete the last line of the file
            sed -i '$ d' $dummycred
        else
            echo ' success'
            break
        fi
    done
fi


echo "Signing $aligned_apk into $dst"
# Quick hack to know if the script is run on Git Bash
which 'cmd' >/dev/null 2>&1
if [ $? -eq 0 ]; then
    apksigner_path=apksigner.bat
else
    apksigner_path="java -jar $(which apksigner)"
fi
# SDK Version 23 is Android 6.0, lower this number if it doesn't work
echo "$password" | $apksigner_path sign --ks $key --min-sdk-version 23 --out "$dst" "$aligned_apk" >/dev/null

echo "Deleting $aligned_apk and signing details"
rm -f $aligned_apk
rm -f $signing_details


echo 'Done'