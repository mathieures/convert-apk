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
echo Usage : %~nx0 [-t] ^<src.apk^> ^<dst.apk^>
echo    -t : use tar instead of powershell (no compression)
exit /b

:begin
set src=%1
set unzipped=%src%.unzipped
set dst=%2
set dst_zip=%dst%.zip


echo unzipping into %unzipped%
md %unzipped% 2>NUL
tar -P -xf %src% -C %unzipped%


echo zipping back into %dst%
if "%use_tar%" == "true" (call :use_tar) else call :use_ps
goto renaming

:use_tar
echo using tar
tar -P -acf %dst_zip% --options compression-level=0 -C %unzipped% *
exit /b

:use_ps
rem If PowerShell 7 is available, use it
where pwsh.exe >NUL 2>&1
if %errorlevel% equ 0 (
    echo using pwsh.exe
    set ps=pwsh.exe
) else (
    echo using powershell.exe
    set ps=powershell.exe
)
rem Compress everything but resources.arsc
call %ps% -nol -noni -nop -c Compress-Archive (Get-ChildItem %unzipped% -Exclude 'resources.arsc') %dst_zip% -Force ; Compress-Archive %unzipped%\resources.arsc -Update %dst_zip% -CompressionLevel NoCompression
exit /b


:renaming
rem Overwrite destination if it exists
if exist %dst% del /q %dst%
rename %dst_zip% %~nx2


echo deleting %unzipped%
rmdir /s /q %unzipped%


:end
echo done