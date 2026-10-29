# Installs Speaky into %LOCALAPPDATA%\Speaky with a desktop and a Start menu
# shortcut, without going through an installer package.
#
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall -Purge
#
# Run it from the folder that holds speaky.exe and binaries\whisper, which is
# what you get after extracting Speaky-win64.zip.

param(
    [switch]$Uninstall,
    [switch]$Purge,
    [switch]$NoLaunch
)

$ErrorActionPreference = "Stop"

$From = $PSScriptRoot
$dest = Join-Path $env:LOCALAPPDATA "Speaky"
$exe = Join-Path $dest "speaky.exe"
$shortcuts = @(
    (Join-Path ([Environment]::GetFolderPath("Desktop")) "Speaky.lnk"),
    (Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Speaky.lnk")
)

function Stop-Speaky {
    Get-Process speaky, whisper-server -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500
}

if ($Uninstall) {
    Stop-Speaky
    foreach ($lnk in $shortcuts) {
        Remove-Item $lnk -Force -ErrorAction SilentlyContinue
    }
    Remove-Item (Join-Path $dest "speaky.exe") -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $dest "binaries") -Recurse -Force -ErrorAction SilentlyContinue
    # Models are a large download, so they stay unless asked for.
    if ($Purge) {
        Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed Speaky, including the downloaded models."
    } else {
        Write-Host "Removed Speaky. Models kept in $dest\models."
    }
    return
}

if (-not (Test-Path (Join-Path $From "speaky.exe"))) {
    throw "No speaky.exe next to this script. Extract the whole zip first, then run install.ps1 from that folder."
}

Stop-Speaky
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item (Join-Path $From "speaky.exe") $exe -Force

$runtime = Join-Path $From "binaries\whisper"
if (Test-Path $runtime) {
    robocopy $runtime (Join-Path $dest "binaries\whisper") /MIR /NJH /NJS /NDL /NP | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "Could not copy the whisper runtime (robocopy $LASTEXITCODE)."
    }
}

$shell = New-Object -ComObject WScript.Shell
foreach ($lnk in $shortcuts) {
    $shortcut = $shell.CreateShortcut($lnk)
    $shortcut.TargetPath = $exe
    $shortcut.WorkingDirectory = $dest
    $shortcut.IconLocation = "$exe,0"
    $shortcut.Description = "Offline dictation for Windows"
    $shortcut.Save()
}

Write-Host "Installed to $dest"
if (-not $NoLaunch) {
    Start-Process -FilePath $exe
}
