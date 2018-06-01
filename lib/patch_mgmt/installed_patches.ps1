$Info = @{}
$arrUpdates = @(Get-Wmiobject -class Win32_QuickFixEngineering -namespace "root\cimv2")
$Info.Add("count", $arrUpdates.Count)
$Info.Add("list", $arrUpdates.HotFixID)
$Info | ConvertTo-Json
