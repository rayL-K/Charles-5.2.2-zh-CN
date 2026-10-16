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

<nul set /p "=需要管理员权限，正在请求提权..."
echo.
set "CPELEVATED=1"
> "%TEMP%\charles-zh-target.txt" echo %TARGET%
powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
goto :eof

:install
rem Charles is single-instance: let the user quit it from the tray instead of
rem killing it, or an unsaved capture session can be lost.
tasklist /fi "IMAGENAME eq Charles.exe" 2>nul | findstr /i /c:"Charles.exe" >nul
if not errorlevel 1 goto :running

if exist "%TARGET%\lib\charles.jar" if not exist "%TARGET%\lib\charles.jar.bak" copy /y "%TARGET%\lib\charles.jar" "%TARGET%\lib\charles.jar.bak" >nul
if exist "%TARGET%\Charles.ini" if not exist "%TARGET%\Charles.ini.bak" copy /y "%TARGET%\Charles.ini" "%TARGET%\Charles.ini.bak" >nul

copy /y "%~dp0lib\charles.jar" "%TARGET%\lib\charles.jar" >nul
set "RC=%errorlevel%"
if not "%RC%"=="0" goto :copyfail
copy /y "%~dp0Charles.ini" "%TARGET%\Charles.ini" >nul
set "RC=%errorlevel%"
if not "%RC%"=="0" goto :copyfail

>>"%LOG%" echo OK
<nul set /p "=汉化完成：重启 Charles 即可。"
echo.
<nul set /p "=备份：lib\charles.jar.bak 与 Charles.ini.bak"
echo.
goto :done

:running
>>"%LOG%" echo FAIL charles_running
<nul set /p "=Charles 正在运行，请先从托盘图标选择 Quit 完全退出，然后重新运行本脚本。"
echo.
<nul set /p "=强制结束可能丢失未保存的抓包会话。"
echo.
goto :done

:copyfail
>>"%LOG%" echo FAIL rc=%RC%
<nul set /p "=复制失败（错误码 %RC%），日志见 %LOG%"
echo.
goto :done

:notarget
>>"%LOG%" echo FAIL target_missing
<nul set /p "=找不到 %TARGET%\Charles.exe，可用参数指定安装目录：安装.bat D:\Charles"
echo.
goto :done

:nopack
>>"%LOG%" echo FAIL pack_incomplete
<nul set /p "=汉化包不完整：缺少 lib\charles.jar 或 Charles.ini"
echo.

:done
del "%TEMP%\charles-zh-target.txt" >nul 2>nul
pause
