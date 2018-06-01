function New-SymLink ($link, $target)
{
    if ($PSVersionTable.PSVersion.Major -ge 5)
    {
        New-Item -Path "$link" -ItemType SymbolicLink -Value "$target"
    }
    else
    {
        $command = "cmd /c mklink /d"
        invoke-expression "$command ""$link"" ""$target"""
    }
}

$found = Get-ChildItem -Path $ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate -Recurse -File PSWindowsUpdate.dll

if (-Not $found) {
    if (-Not (Test-Path $ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate)) {
        New-Item -Path $ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate -ItemType Directory
    }
    New-SymLink -link $ENV:ProgramFiles\WindowsPowerShell\Modules\PSWindowsUpdate\PSWindowsUpdate.dll -target $ENV:ProgramData\PuppetLabs\puppet\cache\lib\patch_mgmt\PSWindowsUpdate.dll
}

Import-Module $ENV:ProgramData\PuppetLabs\puppet\cache\lib\patch_mgmt\PSWindowsUpdate.psd1
$OfferedKBList = Get-WindowsUpdate
$OfferedKBList | select-object -Property KB,Size,Title | ConvertTo-Json
