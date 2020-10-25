
@echo off

rem usuwamy stare pliki
echo Usuwanie katalogow...
rmdir /S /Q .\Source\LBATxt
rmdir /S /Q .\Source\Libs

rem kopiujemy nowe
echo Kopiowanie LBATxt...
xcopy . .\Source\LBATxt /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Libs 1...
xcopy ..\Libs .\Source\Libs\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Release...
xcopy .\Release .\Source\LBATxt\Release\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex2.txt
if errorlevel 1 goto err
echo Kopiowanie Icons...
xcopy .\Icons .\Source\LBATxt\Icons\ /S /V /Y /I /Q
if errorlevel 1 goto err

echo OK!
pause
exit

:err
echo ERROR!!!
pause