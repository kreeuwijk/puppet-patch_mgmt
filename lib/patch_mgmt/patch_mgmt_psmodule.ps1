$result = $True
Try {
    Import-Module -Name PSWindowsUpdate -RequiredVersion "2.0.0.4" -ErrorAction Stop
}
Catch {
    $result = $False
}
$result