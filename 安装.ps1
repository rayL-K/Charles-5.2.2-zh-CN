param([string]$Target = "C:\Program Files\Charles")

$src = $PSScriptRoot
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $admin) {
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -Target `"$Target`""
    exit
}

if (-not (Test-Path "$Target\Charles.exe")) {
    Write-Host "找不到 $Target\Charles.exe，请用 -Target 指定 Charles 安装目录。" -ForegroundColor Red
    Read-Host "回车退出"
    exit 1
}

# Charles must be closed by the user, not killed: it is single-instance and can
# lose an unsaved capture session on a forced exit.
if (Get-Process Charles -ErrorAction SilentlyContinue) {
    Write-Host "Charles 正在运行，请先从托盘图标选择 Quit 完全退出，然后重新运行本脚本。" -ForegroundColor Red
    Read-Host "回车退出"
    exit 1
}

if ((Test-Path "$Target\lib\charles.jar") -and -not (Test-Path "$Target\lib\charles.jar.bak")) {
    Copy-Item "$Target\lib\charles.jar" "$Target\lib\charles.jar.bak" -Force
}
if ((Test-Path "$Target\Charles.ini") -and -not (Test-Path "$Target\Charles.ini.bak")) {
    Copy-Item "$Target\Charles.ini" "$Target\Charles.ini.bak" -Force
}

Copy-Item "$src\lib\charles.jar" "$Target\lib\charles.jar" -Force
Copy-Item "$src\Charles.ini" "$Target\Charles.ini" -Force

Write-Host "汉化完成：重启 Charles 即可。" -ForegroundColor Green
Write-Host "备份在 $Target\lib\charles.jar.bak 和 $Target\Charles.ini.bak，还原=把 .bak 改回原名覆盖。"
Read-Host "回车退出"
