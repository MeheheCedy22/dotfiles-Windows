# dotfiles-Windows

**TBD**

*Note:* Configs and scripts have hardcoded paths.

## Pre-requisites

**TBD**

*Link are currently not working*

- [Alacritty]()
- [PowrShell v7]()
- [Starship]()
- [fzf]() - fuzzy finder
- [eza]() - ls replacement
- [bat]() - cat replacement
- [Git for Windows]() - with Git Bash
- [PSReadLine]() - PowerShell module
- [Fira Code Nerd Font Monospace]()

# Powershell / WindowsPowershell Profile

- add git path to `$env:PATH`
- do these following steps
```ps1
# setup powershell and windows powershell profile to load custom scripts and configs
echo '. "$HOME\.mypwsh\pwsh_profile.ps1"' > $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
echo '. "$HOME\.mypwsh\pwsh_profile.ps1"' > $HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1
echo '. "$HOME\.mypwsh\pwsh_profile.ps1"' > $HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1
echo '. "$HOME\.mypwsh\pwsh_profile.ps1"' > $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# create custom profile dir
mkdir $HOME\.mypwsh\
# copy custom profile scripts to the custom profile dir
cp <PATH_TO_DOTFILES>\Powershell\pwsh_profile.ps1 $HOME\.mypwsh\
```
- From time to time (or after the Starship or Tailscale, has been updated), the cache needs to be regenerated.
  - Do this manually or mechanism needs to be implemented to do this automatically.