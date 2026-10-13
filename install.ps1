$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$AppData = [Environment]::GetFolderPath("ApplicationData")
$SpicetifyDir = Join-Path $AppData "spicetify"
$SpotifyDir = Join-Path $AppData "Spotify"

Write-Host "==> 1. Spotify kornyezet ellenorzese..." -ForegroundColor Cyan

# Prefs fájl előkészítése a detektálási hibák megelőzésére
$PrefsFile = Join-Path $SpotifyDir "prefs"
if (-not (Test-Path $PrefsFile)) {
    New-Item -Path $SpotifyDir -ItemType Directory -Force | Out-Null
    New-Item -Path $PrefsFile -ItemType File -Force | Out-Null
}

Write-Host "==> 2. Spicetify CLI ellenorzese..." -ForegroundColor Cyan
if (-not (Get-Command "spicetify" -ErrorAction SilentlyContinue)) {
    Write-Host "Spicetify CLI nincs telepitve, automatikus letoltes..." -ForegroundColor Yellow
    Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/spicetify/cli/main/install.ps1" | Invoke-Expression
    
    $SpicetifyBin = Join-Path $HOME "spicetify"
    if (Test-Path $SpicetifyBin) {
        $env:PATH += ";$SpicetifyBin"
    }
}

Write-Host "==> 3. Kiegeszitok masolasa a repobol..." -ForegroundColor Cyan
$CustomAppsDir = Join-Path $SpicetifyDir "CustomApps"
$ExtensionsDir = Join-Path $SpicetifyDir "Extensions"

New-Item -Path $CustomAppsDir -ItemType Directory -Force | Out-Null
New-Item -Path $ExtensionsDir -ItemType Directory -Force | Out-Null

Copy-Item -Path (Join-Path $ScriptDir "CustomApps\lyrics-plus") -Destination $CustomAppsDir -Recurse -Force
Copy-Item -Path (Join-Path $ScriptDir "Extensions\adblock.js") -Destination $ExtensionsDir -Force

Write-Host "==> 4. Spicetify konfiguracio beallitasa..." -ForegroundColor Cyan
spicetify config custom_apps lyrics-plus
spicetify config extensions adblock.js

Write-Host "==> 5. Mentes es alkalmazas..." -ForegroundColor Cyan
Get-Process -Name "Spotify" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 1

try {
    spicetify restore backup apply
} catch {
    spicetify backup apply
}

Write-Host "`n==> SIKER! A Spicetify, a gorgetheto Lyrics Plus es az Adblock telepitve." -ForegroundColor Green