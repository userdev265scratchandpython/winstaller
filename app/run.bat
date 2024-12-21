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

:: Définir la commande à exécuter (le script lui-même)
set "command=%0"
set "vbscriptFile=%temp%\runAsAdmin.vbs"
set "tempfile=%temp%\templog4winstaller.txt"
set "configFile=..\data\config.winst"

cd /d "%~dp0"

:: Créer le fichier VBScript pour exécuter le fichier spécifié en tant qu'administrateur
echo Set objShell = CreateObject("Shell.Application")> "%vbscriptFile%"
echo objShell.ShellExecute "cmd.exe", "/c """ ^& WScript.Arguments(0) ^& """", "", "runas", 1 >> "%vbscriptFile%"
echo Set objWshShell = CreateObject("WScript.Shell") >> "%vbscriptFile%"

:: Vérifier si le script s'exécute avec des privilèges élevés
net session >nul 2>&1
if %errorlevel% neq 0 (
    cscript //nologo "%vbscriptFile%" "%command%"
    del "%vbscriptFile%" 2>nul
    exit /b
)

:: Changer de répertoire où se trouve le script
cd /d "%~dp0"

:: Charger les paramètres de configuration à partir de config.winst
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
    echo [ÉCHEC] Fichier de configuration introuvable : %configFile% >> "%tempfile%"
    goto ShowLog
)

:: Définir les chemins en utilisant les valeurs de configuration
set "localInfoPath=..\data\.localinformations"
set "archivePath=..\software\archive.zip"
set "installDirPath= ..\software\installdir.winst"
set "registryFilePath=..\software\registery-add.reg"
set "appName=exemple"
:: Vérifier si le fichier d'informations locales existe
if not exist "%localInfoPath%" (
    echo [ÉCHEC] Fichier d'informations locales introuvable : %localInfoPath% >> "%tempfile%"
    goto ShowLog
)

:: Lire le répertoire d'installation à partir de installdir.winst
set "installDir="
for /f "usebackq delims=" %%i in ("%installDirPath%") do (
    set "installDir=%%i"
)

:: Vérifier si le répertoire d'installation a été trouvé
if not defined installDir (
    echo [ÉCHEC] Répertoire d'installation introuvable dans : %installDirPath% >> "%tempfile%"
    goto ShowLog
)

:: Décompresser l'archive dans le répertoire d'installation
if exist "%archivePath%" (
    echo [    ] Décompression de l'archive...
    powershell -command "Expand-Archive -Path '%archivePath%' -DestinationPath '%installDir%' -Force"
    if %errorlevel% neq 0 (
        echo [ÉCHEC] Échec de la décompression de l'archive. >> "%tempfile%"
        goto ShowLog
    )
    echo [ OK ] Archive décompressée avec succès. >> "%tempfile%"
) else (
    echo [ÉCHEC] Archive introuvable : %archivePath% >> "%tempfile%"
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

:: Vérifier les modifications de registre malveillantes
set "maliciousDetected=false"
set "allowedKeyPrefix=HKEY_CURRENT_USER\Software\%appName%\"

:: Lire le fichier de registre et vérifier les clés autorisées
if "!regfilepresent!" == " 1" (
    if exist "%registryFilePath%" (
        for /f "usebackq delims=" %%j in ("%registryFilePath%") do (
            echo %%j | findstr /i "HKEY_CURRENT_USER" >nul
            if !errorlevel! == 0 (
                echo %%j | findstr /i "^%allowedKeyPrefix%" >nul
                if !errorlevel! neq 0 (
                    echo [ÉCHEC] Entrée de registre potentiellement malveillante détectée : %%j >> "%tempfile%"
                    set "maliciousDetected=true"
                )
            )
        )
    ) else (
        echo [ÉCHEC] Fichier de registre introuvable : %registryFilePath% >> "%tempfile%"
        goto ShowLog
    )
) else (
    echo [INFO] Écriture dans le registre interdite par la configuration de l'installateur.
    echo [INFO] Écriture dans le registre interdite par la configuration de l'installateur. Il est possible qu'aucune modification du registre ne soit nécessaire. >> "%tempfile%"
)
:: Si des modifications malveillantes ont été détectées, quitter
if "!maliciousDetected!" == "true" (
    echo [ÉCHEC] Sortie sans ajouter de modifications au registre en raison de menaces potentielles. >> "%tempfile%"
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

:: Vérifier si regfilepresent est défini sur 1
if "!regfilepresent!" == " 1" (
    echo [    ] Écriture dans le registre...
    regedit /s "%registryFilePath%"
    if %errorlevel% neq 0 (
        echo [ÉCHEC] Échec de l'ajout des modifications au registre. >> "%tempfile%"
        goto ShowLog
    )
    echo [ OK ] Modifications du registre appliquées avec succès. >> "%tempfile%"
) else (
    echo [INFO] Ignorer les modifications du registre car regfilepresent n'est pas défini sur 1. 
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
