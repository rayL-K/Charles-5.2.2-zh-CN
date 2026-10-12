@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0."

set "TARGET=%~1"
if defined CPTARGET set "TARGET=%CPTARGET%"
if not defined TARGET if exist "%TEMP%\charles-zh-target.txt" set /p TARGET=<"%TEMP%\charles-zh-target.txt"
if not defined TARGET set "TARGET=C:\Program Files\Charles"

set "LOG_DIR=%LOCALAPPDATA%\Charles-zh"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>nul
set "LOG=%LOG_DIR%\install.log"

>>"%LOG%" echo ===== charles zh install start =====
>>"%LOG%" echo target=%TARGET%
>>"%LOG%" echo admin=%CPELEVATED%

if not exist "%TARGET%\Charles.exe" goto :notarget
if not exist "%~dp0lib\charles.jar" goto :nopack
if not exist "%~dp0Charles.ini" goto :nopack
if "%CP_TEST%"=="1" goto :install
if defined CPELEVATED goto :install

net session >nul 2>&1
if not errorlevel 1 goto :install

echo 需要管理员权限，正在请求提权...
set "CPELEVATED=1"
> "%TEMP%\charles-zh-target.txt" echo %TARGET%
powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
goto :eof

:install
taskkill /f /im Charles.exe >nul 2>nul
ping -n 3 127.0.0.1 >nul

if exist "%TARGET%\lib\charles.jar" if not exist "%TARGET%\lib\charles.jar.bak" copy /y "%TARGET%\lib\charles.jar" "%TARGET%\lib\charles.jar.bak" >nul
if exist "%TARGET%\Charles.ini" if not exist "%TARGET%\Charles.ini.bak" copy /y "%TARGET%\Charles.ini" "%TARGET%\Charles.ini.bak" >nul

copy /y "%~dp0lib\charles.jar" "%TARGET%\lib\charles.jar" >nul
set "RC=%errorlevel%"
if not "%RC%"=="0" goto :copyfail
copy /y "%~dp0Charles.ini" "%TARGET%\Charles.ini" >nul
set "RC=%errorlevel%"
if not "%RC%"=="0" goto :copyfail

>>"%LOG%" echo OK
echo 汉化完成：重启 Charles 即可。
echo 备份：lib\charles.jar.bak 与 Charles.ini.bak
goto :done

:copyfail
>>"%LOG%" echo FAIL rc=%RC%
echo 复制失败（错误码 %RC%），日志见 %LOG%
goto :done

:notarget
>>"%LOG%" echo FAIL target_missing
echo 找不到 "%TARGET%\Charles.exe"，可用参数指定安装目录：安装.bat "D:\Charles"
goto :done

:nopack
>>"%LOG%" echo FAIL pack_incomplete
echo 汉化包不完整：缺少 lib\charles.jar 或 Charles.ini

:done
del "%TEMP%\charles-zh-target.txt" >nul 2>nul
pause
