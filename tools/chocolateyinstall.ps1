﻿$packageName = 'autoruns'
$url = 'https://download.sysinternals.com/files/Autoruns.zip'
$checksum = '55377AFA1D96C4E64B4D4C486F4CE910DDCFF5A2E2F3C6DDB35183C830A61FF7'
$checksumType = 'sha256'
$url64 = "$url"
$checksum64 = "$checksum"
$checksumType64 = "checksumType"
$fileName = "Autoruns.exe"
$linkName = "Autoruns.lnk"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit "$url64" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType" `
                             -Checksum64 "$checksum64" `
                             -ChecksumType64 "$checksumType64"
$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutFilePath = Join-Path $programs $linkName
$targetPath = Join-Path $toolsDir $fileName
Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
Write-Verbose "Accepting license..."
$regRoot = 'HKCU:\Software\Sysinternals'
$regPkg = 'AutoRuns'
$regPath = Join-Path $regRoot $regPkg
if (!(Test-Path $regRoot)) {New-Item -Path "$regRoot"}
if (!(Test-Path $regPath)) {New-Item -Path "$regRoot" -Name "$regPkg"}
Set-ItemProperty -Path "$regPath" -Name EulaAccepted -Value 1
if ((Get-ItemProperty -Path "$regPath").EulaAccepted -ne 1) {
  throw "Failed setting registry value."
}