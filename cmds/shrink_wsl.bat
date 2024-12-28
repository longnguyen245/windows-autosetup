@echo off
REM Set the path to your VHDX file
set VHDX_PATH="C:\Users\%USERNAME%\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"

REM Create a temporary script for diskpart
echo select vdisk file=%VHDX_PATH% > %temp%\diskpart_script.txt
echo compact vdisk >> %temp%\diskpart_script.txt

REM Run diskpart with the script
diskpart /s %temp%\diskpart_script.txt

REM Clean up the temporary script
del %temp%\diskpart_script.txt

echo Disk compacting complete.
pause
