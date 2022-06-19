@echo off

rem If -t is present
set "use_tar="
if "%1" == "-t" (
    set use_tar=true
    shift
)

if "%2"=="" goto usage
if not "%3"=="" goto usage
goto begin

:usage
echo Usage : %0 [-t] ^<src.apk^> ^<dst.apk^>
echo    -t : use tar instead of powershell (no compression)
exit /b

:begin
set src=%1
set unzipped=%src%.unzipped
set dst=%2

if "%use_tar%" == "true" (
	call uncompress-resources.bat -t %src% %unzipped%
) else (
	call uncompress-resources.bat %src% %unzipped%
)
call align-and-sign.bat %unzipped% %dst%