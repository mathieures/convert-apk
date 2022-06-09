@echo off

if "%2"=="" goto usage
if not "%3"=="" goto usage
goto begin

:usage
echo Usage : %0 ^<src.apk^> ^<dst.apk^>
exit /b

:begin
set src=%1
set unzipped=%src%.unzipped
set dst=%2

call uncompress-resources.bat %src% %unzipped%
call align-and-sign.bat %unzipped% %dst%