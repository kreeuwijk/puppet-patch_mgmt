Try {
    Import-Module -Name PSWindowsUpdate -RequiredVersion '2.0.0.4' -ErrorAction Stop
}
Catch {
    if (-Not (Test-Path "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate")) {
        New-Item -Path "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate" -ItemType Directory
    }
    Copy-Item -Path "$ENV:ProgramData\PuppetLabs\puppet\cache\lib\patch_mgmt\2.0.0.4" -Destination "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate\2.0.0.4" -Recurse -Force
    Import-Module -Name PSWindowsUpdate -RequiredVersion '2.0.0.4'
}

$objSystemInfo     = New-Object -ComObject "Microsoft.Update.SystemInfo"
$objServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$WUInfo            = Get-WUSettings
$Info = @{
    "autoinstall_minor_updates" = [bool]$WUInfo.AutoInstallMinorUpdates
    "detection_frequency"       = $WUInfo.DetectionFrequency
    "report_server_url"         = $WUInfo.WUStatusServer
    "system_needs_reboot"       = [bool]$objSystemInfo.RebootRequired
    "update_server_url"         = $WUInfo.WUServer
    "update_source"             = ($objServiceManager.services | Where-Object IsDefaultAUService -eq 1).Name
    "update_policy"             = $WUInfo.AUOptions
}

$Info | ConvertTo-Json
