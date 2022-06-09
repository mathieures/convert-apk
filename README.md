# Convert .apk files
## Prepare them for Android >= 11 (SDK >= 30)

This repository is a set of scripts written to solved an error appearing when trying to install an app with adb:  
`Failure [-124: Failed parse during installPackageLI: Targeting R+ (version 30 and above) requires the resources.arsc of installed APKs to be stored uncompressed and aligned on a 4-byte boundary]`

Or within Android:  
`There was a problem parsing the package`


# Usage

- In Windows cmd (.bat extensions are optional):  
    `convert-apk.bat <impossible_to_install.apk> <converted.apk>`  
    OR
    ```batch
    uncompress-resources.bat <impossible_to_install.apk> <uncompressed.apk>
    align-and-sign.bat <uncompressed.apk> <converted.apk>
    ```
- In Bash:
    ```bash
    chmod +x uncompress-resources.sh align-and-sign.sh
    ./uncompress-resources.sh <impossible_to_install.apk> <uncompressed.apk>
    ./align-and-sign.sh <uncompressed.apk> <converted.apk>
    ```


# Installation of converted app

You have three ways of doing this:
- Install directly the app with adb:  
    `adb install --no-incremental <converted.apk>`
- Transfer the file with adb then install it manually:  
    `adb push <converted.apk> /sdcard/Download` - will put the file in the Download folder of the internal memory
- Transfer it from the file explorer and install it manually

Note that the last two will probably make Google Play Protect throw a warning during installation.


# Requirements

- [Android Studio command line tools](https://developer.android.com/studio#command-tools): `zipalign`, `keytool`, `apksigner`
- Specifically on Windows:
    - `PowerShell 5` which should be included by default or higher (better)  
    OR
    - WSL to execute the bash scripts
- Specifically on Linux:
    - `zip` and `unzip` commands