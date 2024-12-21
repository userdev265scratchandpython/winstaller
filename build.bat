@echo off
cd cd /d "%~dp0"
set "outf='%~dp0'\unbuild.bat"
cd software
echo veuillez taper un chemin avec lequel votre programme FONCTIONNERA. il est recommandé d'utiliser simplement "C:\Winstaller\" puis le nom de votre application.
set /p "dir=répertoire : "
echo %dir% > installdir.winst
del readme*.txt
cd ..
set "outf=.\unbuild.bat"  REM Définir le chemin de votre fichier de sortie

powershell -command "irm 'https://github.com/userdev265scratchandpython/winstaller/releases/download/unbuild.bat/unbuild.bat' -outfile %outf%"
cd data
echo votre programme écrira-t-il dans le registre ?
echo [INFORMATIONS]
type "readme(config.winst).txt"
echo [script]
:wregp
set /p "wreg=[O/N]"
if "%wreg%" == "O" (
	ren "config1.winst" "config.winst"
	del "config0.winst"
	goto finish
) else if "%wreg%" == "o" (
	ren "config1.winst" "config.winst"
	del "config0.winst"
	goto finish
) else if "%wreg%" == "N" (
	ren "config0.winst" "config.winst"
	del "config1.winst"
	goto finish
) else if "%wreg%" == "n" (
	ren "config0.winst" "config.winst"
	del "config1.winst"
	goto finish
) else (
	echo saisissez une valeur valide
	goto wregp
)

:finish
del readme*.txt
exit /b 0
