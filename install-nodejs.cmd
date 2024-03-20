@echo off
SETLOCAL EnableDelayedExpansion

:::: Run as administrator, AveYo: ps\vbs version
1>nul 2>nul fltmc || (
    set "_=call "%~dpfx0" %*" & powershell -nop -c start cmd -args '/d/x/r',$env:_ -verb runas || (
    >"%temp%\Elevate.vbs" echo CreateObject^("Shell.Application"^).ShellExecute "%~dpfx0", "%*" , "", "runas", 1
    >nul "%temp%\Elevate.vbs" & del /q "%temp%\Elevate.vbs" )
    exit)

:::: Set URL to download Node.js
set "URL=https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi"

:::: Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js is not installed.
    echo Downloading Node.js from %URL% ...
    bitsadmin /transfer "DownloadNodeJS" %URL% "%TEMP%\install_nodejs.msi"
    
    :::: Start Node.js installation without user interaction and add Node.js to the system PATH
    echo Installing Node.js...
    start /wait "" msiexec /i "%TEMP%\install_nodejs.msi" /qn /norestart ADDLOCAL=ALL
    
    :::: Delete the Node.js installer after installation to free up space
    del /f /q "%TEMP%\install_nodejs.msi"    
    
) else (
    echo Node.js is already installed.
)

endlocal
echo Done.
pause
