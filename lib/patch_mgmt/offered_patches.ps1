If ($PSVersionTable.PSVersion.Major -ge 5) {
    $importcmd = 'Import-Module -Name PSWindowsUpdate -RequiredVersion "2.0.0.4" -ErrorAction Stop'
    $copysrc   = "$ENV:ProgramData\PuppetLabs\puppet\cache\lib\patch_mgmt\2.0.0.4"
    $copydest  = "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate\2.0.0.4"
} Else {
    $importcmd = 'Import-Module "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate\PSWindowsUpdate.psd1" -ErrorAction Stop'
    $copysrc   = "$ENV:ProgramData\PuppetLabs\puppet\cache\lib\patch_mgmt\2.0.0.4\*"
    $copydest  = "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate"
}

Try {
    Invoke-Expression $importcmd
}
Catch {
    if (-Not (Test-Path "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate")) {
        New-Item -Path "$ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate" -ItemType Directory
    }
    Copy-Item -Path $copysrc -Destination $copydest -Force
    Invoke-Expression $importcmd
}

$OfferedKBList = Get-WindowsUpdate
$Info = @{}
$Info.Add("count", $OfferedKBList.Count)
$Info.Add("list", $OfferedKBList.KB)
$Details = @{}
$OfferedKBList | ForEach-Object {
    $Details.Add($_.KB, @{
        "Size"  = $_.Size
        "Title" = $_.Title
    })
}
$Info.Add("details", $Details)
#$Info.Add("list", ($OfferedKBList | select-object -Property KB,Size,Title))
$Info | ConvertTo-Json
