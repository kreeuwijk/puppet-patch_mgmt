$arrPSModulePaths = ($ENV:PSModulePath).Split(';')
#Check if one of the paths is in the Program Files folder (not the case for PowerShell 2.0)
$found = $false
$arrPSModulePaths | ForEach-Object {
    if ($_ -like "$ENV:ProgramFiles\*") {
        $found = $true
        $result = $_
    }
}
#If no Program Files-based path is found, fallback to the last entry (which lives under %SystemRoot%)
if (!$found) {
    $result = $arrPSModulePaths | Select-Object -Last 1
}
#Trim any ending backslash as some paths have them and others don't
$result.TrimEnd('\')