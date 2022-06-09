@echo off
setlocal

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

echo unzipping into %unzipped%
md %unzipped% 2>NUL
tar -P -xf %src% -C %unzipped%

echo zipping back into %dst%
tar -P --exclude 'resources.arsc' -a -cf %dst%.zip -C %unzipped% *
rename %dst%.zip %dst%

echo deleting %unzipped%
rmdir /s /q %unzipped%


:end
echo done