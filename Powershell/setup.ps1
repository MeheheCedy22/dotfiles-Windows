Write-host "Add paths from .\$PSScriptRoot\path_list.ps1 to the current session and registry (User scope)"
if (-not (Test-Path -Path .\$PSScriptRoot\path_list.ps1)) {
    Write-host "Error: .\$PSScriptRoot\path_list.ps1 not found. Please ensure the file exists in the current directory." -ForegroundColor Red
    exit 1
}
. .\$PSScriptRoot\add_paths.ps1
Write-host "Setup Powershell and Windows Powershell profile to load custom scripts and configs (also for vscode)"
if (-not (Test-Path -Path .\$PSScriptRoot\copy_profile.ps1)) {
    Write-host "Error: .\$PSScriptRoot\copy_profile.ps1 not found. Please ensure the file exists in the current directory." -ForegroundColor Red
    exit 1
}
. .\$PSScriptRoot\copy_profile.ps1