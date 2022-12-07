<#
.SYNOPSIS

	AutoStart Network AutoConfig Services to Enable and support IEEE802.1X on network adapters.
	
	FileName:    AutoStart-Nework_autoConfig-Services.ps1
    Author:      Mark Messink
    Contact:     
    Created:     21-12-2021
    Updated:     21-11-2022

    Version history:
    1.0.0 - (21-12-2021) Initial Script
	1.0.1 - (21-12-2022) Script verniewd
	1.1.0 - 

.DESCRIPTION
	<wat doet het script in meerdere regels>

.PARAMETER
	<beschrijf de parameters die eventueel aan het script gekoppeld moeten worden>

.INPUTS


.OUTPUTS
	logfiles:
	PSlog_<naam>	Log gegenereerd door een powershell script
	INlog_<naam>	Log gegenereerd door Intune (Win32)
	AIlog_<naam>	Log gegenereerd door de installer van een applicatie bij de installatie van een applicatie
	ADlog_<naam>	Log gegenereerd door de installer van een applicatie bij de de-installatie van een applicatie
	Een datum en tijd wordt automatisch toegevoegd

.EXAMPLE
	./scriptnaam.ps1

.LINK Information

.NOTES
	WindowsBuild:
	Het script wordt uitgevoerd tussen de builds LowestWindowsBuild en HighestWindowsBuild
	LowestWindowsBuild = 0 en HighestWindowsBuild 50000 zijn alle Windows 10/11 versies
	LowestWindowsBuild = 19000 en HighestWindowsBuild 19999 zijn alle Windows 10 versies
	LowestWindowsBuild = 22000 en HighestWindowsBuild 22999 zijn alle Windows 11 versies
	Zie: https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information

#>

#################### Variabelen #####################################
$logpath = "C:\IntuneLogs"
$NameLogfile = "PSlog_AutoStart-Nework_autoConfig-Services.txt"
$LowestWindowsBuild = 0
$HighestWindowsBuild = 50000



#################### Einde Variabelen ###############################


#################### Start base script ##############################
### Niet aanpassen!!!

# Prevent terminating script on error.
$ErrorActionPreference = 'Continue'

# Create logpath (if not exist)
If(!(test-path $logpath))
{
      New-Item -ItemType Directory -Force -Path $logpath
}

# Add date + time to Logfile
$TimeStamp = "{0:yyyyMMdd-HHmm}" -f (get-date)
$logFile = "$logpath\" + "$TimeStamp" + "_" + "$NameLogfile"

# Start Transcript logging
Start-Transcript $logFile -Append -Force

# Start script timer
$scripttimer = [system.diagnostics.stopwatch]::StartNew()

# Controle Windows Build
$WindowsBuild = [System.Environment]::OSVersion.Version.Build
Write-Output "------------------------------------"
Write-Output "Windows Build: $WindowsBuild"
Write-Output "------------------------------------"
If ($WindowsBuild -ge $LowestWindowsBuild -And $WindowsBuild -le $HighestWindowsBuild)
{
#################### Start base script ################################

#################### Start uitvoeren script code ####################
Write-Output "-------------------------------------------------------------------------------------"
Write-Output "### Start uitvoeren script code ###"
Write-Output "-------------------------------------------------------------------------------------"

	Write-Output "-------------------------------------------------------------------"
	Write-Output "--- Enable autostart Wired AutoConfig Service"
	get-service -displayname 'Wired Autoconfig' | set-service -StartupType Automatic -Status Running
	Write-Output "--- Settings and Status:"
	get-service -displayname 'Wired Autoconfig' | select -Property Displayname, Name, starttype, status | FL
	
	Write-Output "-------------------------------------------------------------------"
	Write-Output "--- Enable autostart WLAN AutoConfig Service"
	get-service -displayname 'WLAN Autoconfig' | set-service -StartupType Automatic -Status Running
	Write-Output "--- Settings and Status:"
	get-service -displayname 'WLAN Autoconfig' | select -Property Displayname, Name, starttype, status | FL
	<#	
	Write-Output "-------------------------------------------------------------------"
	Write-Output "--- Enable autostart WWan AutoConfig Service"	
	get-service -displayname 'WWAN Autoconfig' | set-service -StartupType Automatic -Status Running
	Write-Output "--- Settings and Status:"
    get-service -displayname 'WWAN Autoconfig' | select -Property Displayname, Name, starttype, status | FL
	#>
	Write-Output "-------------------------------------------------------------------"
	
Write-Output "-------------------------------------------------------------------------------------"
Write-Output "### Einde uitvoeren script code ###"
Write-Output "-------------------------------------------------------------------------------------"
#################### Einde uitvoeren script code ####################

#################### End base script #######################

# Controle Windows Build
}Else {
Write-Output "-------------------------------------------------------------------------------------"
Write-Output "### Windows Build versie voldoet niet, de script code is niet uitgevoerd. ###"
Write-Output "-------------------------------------------------------------------------------------"
}

#Stop and display script timer
$scripttimer.Stop()
Write-Output "------------------------------------"
Write-Output "Script elapsed time in seconds:"
$scripttimer.elapsed.totalseconds
Write-Output "------------------------------------"

#Stop Logging
Stop-Transcript
#################### End base script ################################

#################### Einde Script ###################################
