@echo off
setlocal enabledelayedexpansion

cls

echo "W     W I" [ ] " W     W I N   N  SSSS TTTTT   A   L     EEEEE RRR   "
echo "W     W  " [ ] " W     W   NN  N S       T    A A  L     E     R  R  "
echo " W W W  I" [ ] "  W W W  I N N N  SSS    T    AAA  L     EEE   RRR   "
echo " W W W  I" [ ] "  W W W  I N  NN     S   T   A   A L     E     R  R  "
echo "  W W"  I" [ ] "   W W   I N   N SSSS    T   A   A LLLLL EEEEE R   R "
echo winstaller
echo:

:: Define the command to run (the script itself)
set "command=%0"
set "vbscriptFile=%temp%\runAsAdmin.vbs"
set "tempfile=%temp%\templog4winstaller.txt"
set "configFile=..\data\config.winst"

cd /d "%~dp0"

:: Create the VBScript file to run the specified file as admin
echo Set objShell = CreateObject("Shell.Application")> "%vbscriptFile%"
echo objShell.ShellExecute "cmd.exe", "/c """ ^& WScript.Arguments(0) ^& """", "", "runas", 1 >> "%vbscriptFile%"
echo Set objWshShell = CreateObject("WScript.Shell") >> "%vbscriptFile%"

:: Check if the script is running with elevated privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    cscript //nologo "%vbscriptFile%" "%command%"
    del "%vbscriptFile%" 2>nul
    exit /b
)

:: Change to the directory where the script is located
cd /d "%~dp0"

:: Load configuration settings from config.winst
if exist "%configFile%" (
    for /f "usebackq tokens=1,* delims=:" %%a in ("%configFile%") do (
        set "key=%%a"
        set "value=%%b"
        if "!key!"=="regfilepresent " (
            set "regfilepresent=!value!"
        )
        set "%%a=%%b"
    )
) else (
    echo [FAIL] Configuration file not found: %configFile% >> "%tempfile%"
    goto ShowLog
)

:: Define paths using configuration values
set "localInfoPath=..\data\.localinformations"
set "archivePath=..\software\archive.zip"
set "installDirPath=..\software\installdir.winst"
set "registryFilePath=..\software\registery-add.reg"
set "appName=exemple"
:: Check if the local information file exists
if not exist "%localInfoPath%" (
    echo [FAIL] Local information file not found: %localInfoPath% >> "%tempfile%"
    goto ShowLog
)

:: Read the install directory from installdir.winst
set "installDir="
for /f "usebackq delims=" %%i in ("%installDirPath%") do (
    set "installDir=%%i"
)

:: Check if install directory was found
if not defined installDir (
    echo [FAIL] Install directory not found in: %installDirPath% >> "%tempfile%"
    goto ShowLog
)

:: Unpack the archive to the install directory
if exist "%archivePath%" (
    echo [    ] Unpacking archive...
    powershell -command "Expand-Archive -Path '%archivePath%' -DestinationPath '%installDir%' -Force"
    if %errorlevel% neq 0 (
        echo [FAIL] Failed to unpack the archive. >> "%tempfile%"
        goto ShowLog
    )
    echo [ OK ] Archive unpacked successfully. >> "%tempfile%"
) else (
    echo [FAIL] Archive not found: %archivePath% >> "%tempfile%"
    goto ShowLog
)

cls

echo "W     W I" [ ] " W     W I N   N  SSSS TTTTT   A   L     EEEEE RRR   "
echo "W     W  " [ ] " W     W   NN  N S       T    A A  L     E     R  R  "
echo " W W W  I" [ ] "  W W W  I N N N  SSS    T    AAA  L     EEE   RRR   "
echo " W W W  I" [ ] "  W W W  I N  NN     S   T   A   A L     E     R  R  "
echo "  W W"  I" [ ] "   W W   I N   N SSSS    T   A   A LLLLL EEEEE R   R "
echo winstaller
echo:

:: Check for malicious registry modifications
set "maliciousDetected=false"
set "allowedKeyPrefix=HKEY_CURRENT_USER\Software\%appName%\"

:: Read registry file and check for allowed keys
if "!regfilepresent!" == " 1" (
    if exist "%registryFilePath%" (
        for /f "usebackq delims=" %%j in ("%registryFilePath%") do (
            echo %%j | findstr /i "HKEY_CURRENT_USER" >nul
            if !errorlevel! == 0 (
                echo %%j | findstr /i "^%allowedKeyPrefix%" >nul
                if !errorlevel! neq 0 (
                    echo [FAIL] Potentially malicious registry entry detected: %%j >> "%tempfile%"
                    set "maliciousDetected=true"
                )
            )
        )
    ) else (
        echo [FAIL] Registry file not found: %registryFilePath% >> "%tempfile%"
        goto ShowLog
    )
) else (
    echo [INFO] writing to the registery was banned by te installer configuration.
    echo [INFO] writing to the registery was banned by te installer configuration. it is possible that no registery modifications are needed. >> "%tempfile%"
)
:: If malicious modifications were detected, exit
if "!maliciousDetected!" == "true" (
    echo [FAIL] Exiting without adding registry modifications due to potential threats. >> "%tempfile%"
    goto ShowLog
)
cls

echo "W     W I" [ ] " W     W I N   N  SSSS TTTTT   A   L     EEEEE RRR   "
echo "W     W  " [ ] " W     W   NN  N S       T    A A  L     E     R  R  "
echo " W W W  I" [ ] "  W W W  I N N N  SSS    T    AAA  L     EEE   RRR   "
echo " W W W  I" [ ] "  W W W  I N  NN     S   T   A   A L     E     R  R  "
echo "  W W"  I" [ ] "   W W   I N   N SSSS    T   A   A LLLLL EEEEE R   R "
echo winstaller
echo:

:: Check if regfilepresent is set to 1
if "!regfilepresent!" == " 1" (
    echo [    ] Writing to registry...
    regedit /s "%registryFilePath%"
    if %errorlevel% neq 0 (
        echo [FAIL] Failed to add registry modifications. >> "%tempfile%"
        goto ShowLog
    )
    echo [ OK ] Registry modifications applied successfully. >> "%tempfile%"
) else (
    echo [INFO] Skipping registry modifications as regfilepresent is not set to 1. 
)
cls

echo "W     W I" [ ] " W     W I N   N  SSSS TTTTT   A   L     EEEEE RRR   "
echo "W     W  " [ ] " W     W   NN  N S       T    A A  L     E     R  R  "
echo " W W W  I" [ ] "  W W W  I N N N  SSS    T    AAA  L     EEE   RRR   "
echo " W W W  I" [ ] "  W W W  I N  NN     S   T   A   A L     E     R  R  "
echo "  W W"  I" [ ] "   W W   I N   N SSSS    T   A   A LLLLL EEEEE R   R "
echo winstaller
echo:

:ShowLog
type "%tempfile%"
del "%tempfile%" 2>nul
exit /b