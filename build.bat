@echo off
cd cd /d "%~dp0"
set "outf='%~dp0'\unbuild.bat"
cd software
echo please type a path your program WILL work with. it is recomended to just use "C:\Winstaller\" then your apps name.
set /p "dir=directrory : "
echo %dir% > installdir.winst
del readme*.txt
cd ..
set "outf=.\unbuild.bat"  REM Define your output file path

cd data
echo will your program write to the registery?
echo [INFORMATIONS]
type "readme(config.winst).txt"
echo [script]
:wregp
set /p "wreg=[Y/N]"
if "%wreg%" == "Y" (
	ren "config1.winst" "config.winst"
	del "config0.winst"
	goto finish
) else if "%wreg%" == "y" (
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
	echo input a valid value
	goto wregp
)

:finish
del readme*.txt
exit /b 0
