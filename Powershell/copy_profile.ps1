# setup powershell and windows powershell profile to load custom scripts and configs (also for vscode)
# if profile files do not exist, they will be created and the custom profile path will be added to them
# if profile files already exist, they will be backed up and the custom profile path will be added to them

$GitRepoPath = "$env:USERPROFILE\dotfiles-Windows\"
$CustomProfileDir = Join-Path $env:USERPROFILE ".mypwsh"
$CustomProfilePath = Join-Path $CustomProfileDir "pwsh_profile.ps1"

$ProfilePaths = @(
    "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
    "$env:USERPROFILE\Documents\PowerShell\Microsoft.VSCode_profile.ps1",
    "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1",
    "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1"
)

foreach ($ProfilePath in $ProfilePaths) {
    Write-Host "Setting up profile: $ProfilePath" -ForegroundColor Cyan
    # Backup existing profile if it exists
    Copy-Item -Path $ProfilePath -Destination "$ProfilePath.bak"
    if (Test-Path -Path $ProfilePath) {
        Write-Host "Backing up existing profile to $ProfilePath.bak" -ForegroundColor Yellow
    }
    else {
        Write-Host "No existing profile found. Creating new profile." -ForegroundColor Green
        New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
        Write-Host "New profile created: $ProfilePath" -ForegroundColor Green
        Write-Host "Adding custom profile path to $ProfilePath" -ForegroundColor Green
        Add-Content -Append -Value ". `"$CustomProfilePath`"" -Path $ProfilePath
    }
}

# create custom profile dir
if (-not (Test-Path -Path "$env:USERPROFILE\.mypwsh")) {
    mkdir $env:USERPROFILE\.mypwsh\
    Write-Host "Created custom profile directory: $env:USERPROFILE\.mypwsh" -ForegroundColor Green
}
else {
    Write-Host "Custom profile directory already exists: $env:USERPROFILE\.mypwsh" -ForegroundColor Yellow
}

# copy custom profile scripts to the custom profile dir
if (Test-Path -Path "$GitRepoPath\Powershell\pwsh_profile.ps1") {
    Copy-Item "$GitRepoPath\Powershell\pwsh_profile.ps1" "$CustomProfileDir\"
    Write-Host "Copied custom profile script to $CustomProfileDir" -ForegroundColor Green
}
else {
    Write-Host "Custom profile script not found in the repository: $GitRepoPath\Powershell\pwsh_profile.ps1" -ForegroundColor Red
}
