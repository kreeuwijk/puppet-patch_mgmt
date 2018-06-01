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

$OfferedKBList = Get-WindowsUpdate
$Info = @{}
$Info.Add("count", $OfferedKBList.Count)
$Info.Add("info", ($OfferedKBList | select-object -Property KB,Size,Title))
$Info | ConvertTo-Json
