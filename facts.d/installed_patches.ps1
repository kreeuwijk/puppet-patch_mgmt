$InstalledKBList = Get-Wmiobject -class Win32_QuickFixEngineering -namespace "root\cimv2" | select-object -Property HotFixID | ConvertTo-Json
Write-Host "patch_mgmt_installed_KBs=$InstalledKBList"