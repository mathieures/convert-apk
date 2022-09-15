# Convert .apk files
## Prepare them for Android >= 11 (SDK >= 30)

This repository is a set of scripts written to solved an error appearing when trying to install an app with adb:  
`Failure [-124: Failed parse during installPackageLI: Targeting R+ (version 30 and above) requires the resources.arsc of installed APKs to be stored uncompressed and aligned on a 4-byte boundary]`

Or within Android:  
`There was a problem parsing the package`

I originally found the solution thanks to [this comment by T Aria on StackOverflow](https://stackoverflow.com/a/69893912).

[Full example at the bottom.](#full-example)


# Usage

- In Windows cmd:  
    ```batch
    convert-apk.bat [-t] <impossible_to_install.apk> <converted.apk>
    ```
    OR
    ```batch
    uncompress-resources.bat [-t] <impossible_to_install.apk> <uncompressed.apk>
    align-and-sign.bat <uncompressed.apk> <converted.apk>
    ```
- In Bash:
    ```bash
    chmod +x convert-apk.sh
    ./convert-apk.sh [-t] <impossible_to_install.apk> <converted.apk>
    ```
    OR
    ```bash
    chmod +x uncompress-resources.sh align-and-sign.sh
    ./uncompress-resources.sh [-t] <impossible_to_install.apk> <uncompressed.apk>
    ./align-and-sign.sh <uncompressed.apk> <converted.apk>
    ```
- In Git Bash:
    ```bash
    ./convert-apk.sh -t <impossible_to_install.apk> <converted.apk>
    ```
    OR
    ```bash
    ./uncompress-resources.sh -t <impossible_to_install.apk> <uncompressed.apk>
    ./align-and-sign.sh <uncompressed.apk> <converted.apk>
    ```


# Installation of converted app

You have three ways of doing this:
- Install directly the app with adb:  
    `adb install --no-incremental <converted.apk>`
- Transfer the file with adb then install it manually:  
    `adb push <converted.apk> /sdcard/Download` - will put the file in the Download folder of the *internal* memory
- Transfer it from the file explorer and install it manually

Note that the last two will probably make Google Play Protect throw a warning during installation.


# Tweaking

You can change several things in the scripts to customize them. The lines where things can be changed are marked in the files.

- In `align-and-sign.bat` and `align-and-sign.sh`:
    - the key path and the key password, to use an already existing one
    - the first letter of "yes" in your language could be different from the ones supported
    - the default minimum SDK version for `apksigner` can be lowered if you encounter problems while signing the apk (at the cost of "security", see [the documentation](https://developer.android.com/studio/command-line/apksigner#options))


# Requirements

- [Android Studio command line tools](https://developer.android.com/studio#command-tools): `zipalign` and `apksigner` must be in your PATH
- [Java](https://www.oracle.com/java/technologies/downloads/): `keytool` must be in your PATH
- Specifically on Windows:
    - `PowerShell 5` (included by default) or `PowerShell 7` (faster)  
    OR
    - Git Bash (use `-t` for `uncompress-resources.sh`)  
    OR
    - WSL
- Specifically on Linux:
    - `zip` and `unzip` commands


# Full example

Suppose a `example-app.apk` that is impossible to install:

- In Windows cmd:
    ```batch
    git clone https://github.com/mathieures/convert-apk.git
    cd convert-apk
    copy ..\example-app.apk .
    convert-apk.bat example-app.apk new-example-app.apk
    ```
- In Git Bash:
    ```bash
    git clone https://github.com/mathieures/convert-apk.git
    cd convert-apk
    cp ../example-app.apk .
    ./convert-apk.sh -t example-app.apk new-example-app.apk
    ```
- On Linux:
    ```bash
    git clone https://github.com/mathieures/convert-apk.git
    cd convert-apk
    cp ../example-app.apk .
    chmod +x *.sh
    ./convert-apk.sh example-app.apk new-example-app.apk
    ```