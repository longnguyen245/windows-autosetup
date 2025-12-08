@echo off

for /f "tokens=2 delims=," %%a in ('tasklist /fi "imagename eq WindowsTerminal.exe" /fo csv /nh') do (
    set PID=%%~a
)

if defined PID (
    taskkill /F /PID %PID%
)

start "" cmd /c "sudo scoop update * & scoop cleanup * & scoop cache rm *"
exit
