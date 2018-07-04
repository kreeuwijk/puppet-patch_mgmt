$Info = @{}
$arrUpdates = @(Get-CimInstance -ClassName Win32_QuickFixEngineering -Namespace "root\cimv2")
$Info.Add("count", $arrUpdates.Count)
$Info.Add("list", $arrUpdates.HotFixID)
$Info | ConvertTo-Json
