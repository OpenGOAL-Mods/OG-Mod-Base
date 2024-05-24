@echo off
set releaseDir=%cd%\ReleaseTemplate

echo Creating release directory %releaseDir% ...
if not exist %releaseDir% mkdir %releaseDir%

echo Copying gk.exe, extractor.exe, and goalc.exe ...
copy "..\..\out\build\Release\bin\gk.exe" "%releaseDir%\"
copy "..\..\out\build\Release\bin\extractor.exe" "%releaseDir%\"
copy "..\..\out\build\Release\bin\goalc.exe" "%releaseDir%\"
xcopy "..\..\out\build\Release\bin\SND\" "%releaseDir%\SND\"

echo Copying data folder ...
mkdir "%releaseDir%\data\game"
xcopy /E /I "..\..\goal_src" "%releaseDir%\data\goal_src\"
xcopy /E /I "..\..\custom_levels" "%releaseDir%\data\custom_levels\"
xcopy /E /I "..\..\decompiler\config" "%releaseDir%\data\decompiler\config\"
xcopy /E /I "..\..\game\" "%releaseDir%\data\game\"
xcopy /E /I "..\..\graphics" "%releaseDir%\data\graphics\"


echo Done!
