Import-Module $ENV:ProgramData\PuppetLabs\puppet\cache\lib\patch_mgmt\PSWindowsUpdate.psd1
$OfferedKBList = Get-WindowsUpdate | select-object -Property KB,Size,Title | ConvertTo-Json -Compress
Write-Host "patch_mgmt_offered_updates=$OfferedKBList"
