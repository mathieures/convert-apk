@echo off

if "%2"=="" goto usage
if not "%3"=="" goto usage
goto begin

:usage
echo Usage : %0 ^<src.apk^> ^<dst.apk^>
exit /b

:begin
set src=%1
set aligned_apk=%src%.aligned
set dst=%2
set signing_details=%dst%.idsig

rem Change these if you use a custom key
set key=%tmp%\signing_key
set password=password

rem File with dummy credentials in case of a new key
set dummycred=%tmp%\dummy_cred
rem File containing locale info
set localeinfo=%tmp%\locale_info


echo aligning %src% into %aligned_apk%
zipalign -p 4 %src% %aligned_apk%


if exist %key% (
    echo using existing key %key%
    goto sign
)

echo creating key %key%
rem Newlines to pass the prompts
 >%dummycred% echo %password%
>>%dummycred% echo %password%
>>%dummycred% echo;
>>%dummycred% echo;
>>%dummycred% echo;
>>%dummycred% echo;
>>%dummycred% echo;
>>%dummycred% echo;

rem Take into account the language to reply the local "yes"
echo determining locale info...
if exist %localeinfo% (
    echo using existing %localeinfo%
) else (
    systeminfo > %localeinfo%
)

type %localeinfo% | find "en;">NUL && goto english_yes
type %localeinfo% | find "fr;">NUL && goto french_yes
goto other_yes

:english_yes
echo English detected, using 'y' as yes
>>%dummycred% echo; y
goto after_yes

:french_yes
echo French language detected, using 'o' as yes
>>%dummycred% echo; o
goto after_yes

:other_yes
rem The German yes starts with 'j'; feel free to change if it doesn't work
echo other language detected, using 'j' as yes
>>%dummycred% echo; j
goto after_yes


:after_yes
type %dummycred% | keytool -genkey -keystore %key% -keyalg RSA -keysize 2048 -validity 10000


:sign
echo signing %aligned_apk% into %dst%
rem No space before the pipe, else it is picked up by echo
echo %password%| apksigner sign --ks %key% --out %dst% %aligned_apk%


echo Deleting %aligned_apk% and signing details
del /q %aligned_apk%
del /q %signing_details%


:end
echo done