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
set dst_zip=%dst%.zip

echo unzipping into %unzipped%
md %unzipped% 2>NUL
tar -P -xf %src% -C %unzipped%


echo zipping back into %dst% (slow process)
rem If PowerShell 7 is available, use it
where pwsh.exe >NUL 2>&1
if %errorlevel% equ 0 (
    set ps=pwsh.exe
) else (
    set ps=powershell.exe
)

rem Compress everything but resources.arsc
call %ps% -nol -noni -nop -c Compress-Archive (Get-ChildItem %unzipped% -Exclude 'resources.arsc') %dst_zip% ; Compress-Archive %unzipped%\resources.arsc -Update %dst_zip% -CompressionLevel NoCompression
rename %dst_zip% %dst%

echo deleting %unzipped%
rmdir /s /q %unzipped%


:end
echo done