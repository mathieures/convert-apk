@echo off
setlocal

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
echo Usage : %~nx0 [-t] ^<src.apk^> ^<dst.apk^>
echo    -t : use tar instead of powershell (no compression)
exit /b

:begin
set src=%1
set unaligned_unsigned=%src%.zip
set dst=%2

if "%use_tar%" == "true" (
	call uncompress-resources.bat -t %src% %unaligned_unsigned%
) else (
	call uncompress-resources.bat %src% %unaligned_unsigned%
)
call align-and-sign.bat %unaligned_unsigned% %dst%

rem Delete the temporary file
del %unaligned_unsigned%