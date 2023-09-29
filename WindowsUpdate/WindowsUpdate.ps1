#Script that repairs and clean Windows Update and install the new updates
#Author: Martin Eberle
#Version: 1.0
#Date: 2022-08-23
#No distribution allowed without permission of the author
#--------------------------------------------------------------
#Variables
$SilentMode = $false
#Check if admin rights are available if not start automatically with admin rights
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$ExecutionPolicy = Get-ExecutionPolicy
if ($IsAdmin -eq $false -or $ExecutionPolicy -ne "RemoteSigned")
{
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy RemoteSigned -File `"$PSCommandPath`"" -Verb RunAs -Verbose
    exit
}
#Function to ask the user if he wants to continue
function Show-MessageBox($Type)
{
    # Load the necessary assembly for Windows Forms
    Add-Type -AssemblyName System.Windows.Forms
    #Switch Function with two types of Messages
    switch ($Type)
    {
        "StartScript" {
            $Icon = [System.Windows.Forms.MessageBoxIcon]::Warning
            $Buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
            $Title = "Windows Update Installer by ReichenauGemuese"
            $Message = "Es muss dringend nach Updates gesucht werden. Darf der Vorgang fortgesetzt werden? Ihr Computer wird nach Abschluss des Vorgangs neu gestartet."
        }
        "InformUser" {
            $Icon = [System.Windows.Forms.MessageBoxIcon]::Information
            $Buttons = [System.Windows.Forms.MessageBoxButtons]::OK
            $Title = "Windows Update Installer by ReichenauGemuese"
            $Message = "Bitte speichern Sie Ihre Arbeit und schließen Sie alle Programme. Ihr Computer wird nach Abschluss des Vorgangs automatisch neu gestartet."
        }
    }
    if ($Type -eq "StartScript")
    {
        return [System.Windows.Forms.MessageBox]::Show($Message,$Title,$Buttons,$Icon)
    }
    else
    {
        [System.Windows.Forms.MessageBox]::Show($Message,$Title,$Buttons,$Icon)
    }
}
#Function to check if PSWindowsUpdate module is installed and install it if necessary
function CheckPSWindowsUpdate
{
    $PSWindowsUpdate = Get-Module -ListAvailable -Name PSWindowsUpdate
    if ($null -eq $PSWindowsUpdate)
    {
        Install-Module -Name PSWindowsUpdate -Force
    }
    Update-Module -Name PSWindowsUpdate -Force -Verbose
    Import-Module -Name PSWindowsUpdate -Force -Verbose
}
function CheckPSDefenderModule
{
    $PSDefender = Get-Module -ListAvailable -Name PSDefender
    if ($null -eq $PSDefender)
    {
        Install-Module -Name PSDefender -Force
    }
    Update-Module -Name PSDefender -Force -Verbose
    Import-Module -Name PSDefender -Force -Verbose
}
#Reset Windows Update Components
function ResetWindowsUpdate
{
    Reset-WUComponents -Verbose
}
#Get the newes updates from Microsoft
function GetNewUpdates
{
    Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -AutoReboot -Verbose
}
#Defender Update
function UpdateDefender
{
    Update-MpSignature -Verbose -Force
}
#Main Function
function MainFunction{
    Write-Host "Starting script to get all updates from Microsoft and clean Windows Update before..." -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "PowerShell ist elevated: $IsAdmin and ExecutionPolicy is: $ExecutionPolicy" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "Starting procedure..." -ForegroundColor Yellow -BackgroundColor Black
    CheckPSWindowsUpdate
    CheckPSDefenderModule
    ResetWindowsUpdate
    GetNewUpdates
    UpdateDefender
    Read-Host "Press any key to continue..."
}
#Check if the script is started in silent mode or not
If ($SilentMode -eq $false)
{
    if (Show-MessageBox "StartScript" -eq "Ok"){
        Show-MessageBox "InformUser"
        MainFunction
    }else {
        exit
    }
}
else
{
    MainFunction
}