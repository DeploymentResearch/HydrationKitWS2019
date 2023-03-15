<#

************************************************************************************************************************

Created:	2019-04-22
Version:	1.0

Disclaimer:
This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the author or DeploymentArtist.

Author - Johan Arwidmark
    Twitter: @jarwidmark
    Blog   : http://deploymentresearch.com

************************************************************************************************************************

#>


$TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$Deployroot = $tsenv.Value("DeployRoot")
$env:PSModulePath = $env:PSModulePath + ";$deployRoot\Tools\Modules"

Import-Module -Name HydrationLogging

Set-HYDLogPath
write-HYDLog -Message "Starting setup... "

# Figure out Source path
If($psISE){
    $SourcePath = Split-Path -parent $psISE.CurrentFile.FullPath
}
else{
    $SourcePath = $PSScriptRoot
}

$SetupFile = "$SourcePath\Source\Setup.exe"
$ConfigurationFile = "$SourcePath\ConfigurationFile.ini"
$Arguments = "/configurationfile=""$ConfigurationFile"""

# Validation
if (!(Test-Path -path $SetupFile)) {Write-HYDLog "Could not find SQL Server Setup files, aborting..." -LogLevel 2;Break}
if (!(Test-Path -path $ConfigurationFile)) {Write-HYDLog "Could not find SQL Server configuration files, aborting..." -LogLevel 2;Break}

# Install SQL Server
Write-HYDLog "About to run the following command: $SetupFile $Arguments" 
Start-Process -FilePath $SetupFile -ArgumentList $Arguments -NoNewWindow -Wait -Passthru

Write-HYDLog "Setup completed..." 

