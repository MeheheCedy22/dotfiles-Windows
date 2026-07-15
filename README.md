# dotfiles-Windows

## About

My Windows dotfiles

## Installation

### Pre-requisites

Install following software before using this repo:

- [Windows Terminal](https://github.com/microsoft/terminal) or [Alacritty](https://github.com/alacritty/alacritty)
- [PowrShell v7+](https://github.com/PowerShell/PowerShell) (also known as PowerShell Core)
- [Starship](https://github.com/starship/starship) - shell prompt
- [fzf](https://github.com/junegunn/fzf) - fuzzy finder
- [eza](https://github.com/eza-community/eza) - ls replacement
- [bat](https://github.com/sharkdp/bat) - cat replacement
- [Git](https://github.com/git-for-windows/git/) (* for Windows with Git Bash)
- [PSReadLine](https://github.com/PowerShell/PSReadLine) - PowerShell module

Good addons:

- [Fira Code Nerd Font Monospace](https://www.nerdfonts.com/)

### Clone the repo

```ps1
cd $env:USERPROFILE
git clone https://github.com/MeheheCedy22/dotfiles-Windows.git
```

### Setup Powershell / Windows Powershell

**Complete**

- to setup PowerShell and Windows PowerShell profiles run the [setup.ps1](./Powershell/setup.ps1) script in PowerShell:
```ps1
. $env:USERPROFILE\dotfiles-Windows\Powershell\setup.ps1
```

**Partial**

- to add custom paths to the PATH environment variable, run [add_paths.ps1](./Powershell/add_paths.ps1) script in PowerShell:
- paths can be modified in the [path_list.ps1](./Powershell/path_list.ps1) file
```ps1
. $env:USERPROFILE\dotfiles-Windows\Powershell\add_paths.ps1
```
- to setup PowerShell and Windows PowerShell profile to load custom scripts and configs, run the [copy_profile.ps1](./Powershell/copy_profile.ps1) script in PowerShell:
```ps1
. $env:USERPROFILE\dotfiles-Windows\Powershell\copy_profile.ps1
```
**Note:** From time to time the cache needs to be regenerated. For now it is done manually.

## TODOs

- [ ] add mechanism to automatically update the cache without performance hit