$result = $True
$importcmd = 'Import-Module -Name PSWindowsUpdate -RequiredVersion "2.0.0.4" -ErrorAction Stop'

Try {
    Invoke-Expression $importcmd
}
Catch {
    $result = $False
}
$result