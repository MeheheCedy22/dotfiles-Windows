# 1. Define the paths you want to verify or add.
# (We resolve the %USERPROFILE% environment variable automatically)

. "$PSScriptRoot\path_list.ps1"

# 2. CHOOSE SCOPE: Change "User" to "Machine" if you want to apply system-wide (requires Admin).
$Scope = "User" 

# 3. Get the current clean registry path for that scope
$CurrentRegPath = [System.Environment]::GetEnvironmentVariable("Path", $Scope)
$CurrentPathList = $CurrentRegPath -split ';' | Where-Object { $_.Trim() -ne "" }

# Convert all paths to a standardized format (removing trailing backslashes) for accurate comparison
$StandardizedCurrent = $CurrentPathList | ForEach-Object { $_.TrimEnd('\') }
$UpdatedPathsList = [System.Collections.Generic.List[string]]::new($CurrentPathList)

$ChangesMade = $false

foreach ($Path in $PathsToAdd) {
    # Strip trailing backslash for comparison
    $CleanPath = $Path.TrimEnd('\')
    
    if ($StandardizedCurrent -notcontains $CleanPath) {
        $UpdatedPathsList.Add($Path)
        Write-Host "[ADDING] -> $Path" -ForegroundColor Green
        $ChangesMade = $true
    }
    else {
        Write-Host "[EXISTS] -> $Path" -ForegroundColor Gray
    }
}

# 4. Save back to Registry and update current session only if changes were made
if ($ChangesMade) {
    # Save permanently
    $NewRegPathValue = $UpdatedPathsList -join ';'
    [System.Environment]::SetEnvironmentVariable("Path", $NewRegPathValue, $Scope)
    
    # Update the current running terminal session so you don't have to restart it
    foreach ($Path in $PathsToAdd) {
        if ($env:PATH -split ';' -notcontains $Path) {
            $env:PATH += ";$Path"
        }
    }
    
    Write-Host "`nEnvironment updated permanently ($Scope scope) and applied to current session!" -ForegroundColor Cyan
}
else {
    Write-Host "`nAll paths are already configured correctly. No registry changes made." -ForegroundColor Yellow
}