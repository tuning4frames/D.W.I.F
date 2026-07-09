$ErrorActionPreference = "Stop"

function Ensure-WingetPackage {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Ids,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [string]$CheckCommand = $null,
    [switch]$Optional
  )

  if ($CheckCommand -and (Get-Command $CheckCommand -ErrorAction SilentlyContinue)) {
    Write-Host "$Name is already installed."
    return $true
  }

  foreach ($id in $Ids) {
    Write-Host "Installing $Name..."
    & winget install --id $id --exact --accept-package-agreements --accept-source-agreements --silent
    if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq -1978335189) {
      Write-Host "  $Name ready."
      return $true
    }
    Write-Host "  winget could not install $Name using id '$id'."
  }

  if ($Optional) {
    Write-Host "  Continuing without $Name."
    return $false
  }

  throw "Failed to install $Name."
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "winget is required. Install App Installer from Microsoft Store, then rerun this script."
}

Ensure-WingetPackage -Ids @("OpenJS.NodeJS.LTS") -Name "Node.js LTS" -CheckCommand "node"
Ensure-WingetPackage -Ids @("Rustlang.Rustup") -Name "Rustup" -CheckCommand "rustup"
Ensure-WingetPackage -Ids @("Microsoft.VisualStudio.2022.BuildTools") -Name "Visual Studio Build Tools" -CheckCommand "msbuild"
Ensure-WingetPackage -Ids @("ImageMagick.ImageMagick") -Name "ImageMagick" -CheckCommand "magick"
Ensure-WingetPackage -Ids @("gifski.gifski", "ImageOptim.gifski") -Name "gifski" -CheckCommand "gifski" -Optional

if (Test-Path ".\package.json") {
  Write-Host ""
  Write-Host "Installing npm dependencies..."
  npm install

  Write-Host ""
  Write-Host "Starting D.W.I.F...."
  npm run tauri:dev
  exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Windows prerequisites ready."
Write-Host "If Visual Studio Build Tools opened an interactive installer, make sure 'Desktop development with C++' is selected."
Write-Host "Next steps:"
Write-Host "  npm install"
Write-Host "  npm run tauri:dev"
