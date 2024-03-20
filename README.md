# Nodejs Installation Script

This repository contains a script that automates the process of installing Nodejs on Windows systems.

## Functionality

- **Automatic Installation**: The script handles the entire installation process automatically, from downloading the Nodejs installer to configuring the installation options.
- **Requirements**: It requires a Windows operating system with an active internet connection.
- **Customizable Nodejs Version**: While the default Nodejs version included in the script is `20.11.1`, users can easily modify it by replacing the URL with the desired version available on the [Nodejs official website](https://nodejs.org/dist/).

## Usage

1. **Download Script**: Users can download the provided `.cmd` file from this repository or create a new file using a text editor and save it with the `.cmd` extension.

2. The script is configured to run with **administrator privileges** automatically to ensure successful installation.

3. **Execution**: Upon execution, the script automatically checks if Nodejs is already installed. If not, it proceeds to download and install Nodejs. If Nodejs is already installed, the script notifies the user accordingly.

## Script

The repository contains a `.cmd` script that encapsulates the installation process. The script is thoroughly documented for ease of understanding and customization.

```batch
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
```

## Additional Notes

- Upon execution, the script will download the Nodejs installer, install Nodejs silently (without user interaction), and add Nodejs to the system PATH.
- After installation, the Nodejs installer is deleted from the temporary directory to free up space.

## Disclaimer
This script is provided as-is, without any warranties or guarantees. Use it at your own risk. Make sure to review and understand the script before executing it.
