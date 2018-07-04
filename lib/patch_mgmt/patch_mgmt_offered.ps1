Import-Module -Name PSWindowsUpdate -RequiredVersion "2.0.0.4" -ErrorAction Stop
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
