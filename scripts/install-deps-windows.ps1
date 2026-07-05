$ErrorActionPreference = "Stop"

function Require-Command {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$InstallHint
  )

  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "$Name is required. $InstallHint"
  }
}

function Install-WingetPackage {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Ids,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [switch]$Optional
  )

  foreach ($id in $Ids) {
    Write-Host "Installing $Name..."
    & winget install --id $id --exact --accept-package-agreements --accept-source-agreements --silent

    if ($LASTEXITCODE -eq 0) {
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

Require-Command -Name "winget" -InstallHint "Install App Installer from Microsoft Store, then rerun this script."

$packages = @(
  @{ Ids = @("OpenJS.NodeJS.LTS"); Name = "Node.js LTS" },
  @{ Ids = @("Rustlang.Rustup"); Name = "Rustup" },
  @{ Ids = @("Microsoft.VisualStudio.2022.BuildTools"); Name = "Visual Studio Build Tools" },
  @{ Ids = @("ImageMagick.ImageMagick"); Name = "ImageMagick (optional utility)" },
  @{ Ids = @("gifski.gifski", "ImageOptim.gifski"); Name = "gifski (optional high-quality GIF encoder)"; Optional = $true }
)

foreach ($package in $packages) {
  Install-WingetPackage -Ids $package.Ids -Name $package.Name -Optional:($package.Optional -eq $true) | Out-Null
}

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
Write-Host "Windows prerequisites requested."
Write-Host "If Visual Studio Build Tools opened an interactive installer, make sure 'Desktop development with C++' is selected."
Write-Host "Next steps:"
Write-Host "  npm install"
Write-Host "  npm run tauri:dev"
