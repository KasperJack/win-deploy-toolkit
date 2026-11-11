<#
    Author: Me
    Version: 1.0 (Beta)
    Description: This script creates a boom file on the desktop
#>

Set-Content -Path "$env:USERPROFILE\Desktop\boom.txt" -Value "boom"


<#

# Search all fixed and removable drives for the one containing your Installers folder

$SourceDrive = $null
foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
    $path = "$($drive.Root)Installers"
    if (Test-Path $path) {
        $SourceDrive = $drive.Root
        break
    }
}

if (-not $SourceDrive) {
    Write-Error "Could not find the Installers drive! Please ensure Flash Drive B is plugged in."
    exit 1
}

Write-Host "Found Data Drive at: $SourceDrive"

# 1. Run Snappy Driver Installer from Flash Drive B
$sdiPath = Join-Path $SourceDrive "Installers\SDI\SDI_x64.exe"
if (Test-Path $sdiPath) {
    Write-Host "Starting Driver Installation via SDI..."
    Start-Process -FilePath $sdiPath -ArgumentList "-autoinstall -noserver -reboot" -Wait
}

# 2. Install Software from Flash Drive B
$softwarePath = Join-Path $SourceDrive "Installers\Software"

if (Test-Path "$softwarePath\winrar.exe") {
    Write-Host "Installing WinRAR..."
    Start-Process -FilePath "$softwarePath\winrar.exe" -ArgumentList "/S" -Wait
}

if (Test-Path "$softwarePath\vlc.exe") {
    Write-Host "Installing VLC..."
    Start-Process -FilePath "$softwarePath\vlc.exe" -ArgumentList "/S" -Wait
}

Write-Host "All post-install tasks complete!"


#>