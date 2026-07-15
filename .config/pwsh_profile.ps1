# --------------------------------------------------------------
# 1. Cache Setup & Initialization
# --------------------------------------------------------------

if ($PSVersionTable.PSEdition -ne 'Core') {
    # Runs in Windows PowerShell 5.1 and older

    # enable command history
    Set-PSReadLineOption -PredictionSource History
    # do not save wrong commands (when hit 'Enter' error pops up but from PSReadLine not the powershell itself)
    Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine
    # change to ListView instead of inline suggestion
    Set-PSReadLineOption -PredictionViewStyle ListView
}

$CacheDir = "$HOME\.mypwsh\cache"

if (-not (Test-Path -Path $CacheDir)) {
    New-Item -ItemType Directory -Path $CacheDir | Out-Null
}

# --- Starship Initialization ---
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
$StarshipCache = Join-Path $CacheDir "starship_init.ps1"

if (-not (Test-Path -Path $StarshipCache)) {
    & 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-File -FilePath $StarshipCache -Encoding utf8
}
. $StarshipCache


# --- Tailscale Initialization ---
$TailscaleCache = Join-Path $CacheDir "tailscale_completion.ps1"

if (-not (Test-Path -Path $TailscaleCache)) {
    tailscale completion powershell | Out-File -FilePath $TailscaleCache -Encoding utf8
}
. $TailscaleCache

# --------------------------------------------------------------
# 2. Aliases
# --------------------------------------------------------------
# Not needed for less, grep, tail, head, vim, touch, wc, which, uniq because they are in path and do not have Windows counterparts.

Set-Alias -Name "find_linux" -Value "C:\Program Files\Git\usr\bin\find.exe"
Set-Alias -Name "sort_linux" -Value "C:\Program Files\Git\usr\bin\sort.exe"

Set-Alias bb bat

# --------------------------------------------------------------
# 3. Custom Functions
# --------------------------------------------------------------
function cheat {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$Command
    )
    Process {
        Invoke-RestMethod -Uri "https://cht.sh/$Command"
    }
}

function qr {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$inputString,
        [switch]$isURL
    )
    Process {
        if ([string]::IsNullOrWhiteSpace($inputString))
        {
            return
        }

        if ($isURL)
        {
            if ($inputString -notmatch '^https?://') {
                $inputString = "https://$inputString"
            }
        }
        
        C:\Windows\System32\curl.exe https://qrenco.de/$inputString
    }
}

function lss {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$params
    )

    process {
        # If piped input exists, use it; otherwise, use the passed $params
        $finalParams = if ($params.Count -eq 0) { $_ } else { $params }

        if ($params.Count -gt 0)
        {
            & "$env:LOCALAPPDATA\Microsoft\WinGet\Links\eza.exe" -alh --smart-group --color=auto --group-directories-first --icons=auto --absolute=on $finalParams
        }
        else
        {
            & "$env:LOCALAPPDATA\Microsoft\WinGet\Links\eza.exe" -alh --smart-group --color=auto --group-directories-first --icons=auto $finalParams
        }
    }
}

function ff {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$params
    )

    process {
        # if there is some piped input, than use it as piped input (can't have params / do not need params)
        if ($_ -ne $NULL)
        {
            foreach ($var in $_)
            {
                $inputData += $var.ToString() + "`n"
            }
        }
    }

    end {
        # remove last endline
        $inputData = $inputData -replace "(\r?\n)$", ""

        if ($_ -ne $NULL)
        {
            $inputData | & "$env:LOCALAPPDATA\Microsoft\WinGet\Links\fzf.exe" --height 75% --layout reverse --multi --border --preview 'bat --color=always {}'
        } 
        else {
            # there is no piped input, can use additional params
            & "$env:LOCALAPPDATA\Microsoft\WinGet\Links\fzf.exe" --height 75% --layout reverse --multi --border --preview 'bat --color=always {}' $params
        }
    }
}

# --------------------------------------------------------------
# 4. FZF History (Copyright (C) 2024 Kenichi Kamiya)
# --------------------------------------------------------------
function Invoke-FzfHistory ([String]$fuzzy) {
    $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems()
    $uniqueCommands = Get-UniqueReverseHistory $history
    $matched = $uniqueCommands -join "`0" | fzf --read0 --layout reverse  --border --scheme=history --query=$fuzzy
    
    # fzf output is captured as a string array if it contains newlines.
    # Join them back with the current system newline.
    if ($matched) {
        return $matched -join [System.Environment]::NewLine
    }
}

# Internal helper to process history items: reverse and unique
function Get-UniqueReverseHistory ([Object[]]$historyItems) {
    $set = [System.Collections.Generic.HashSet[string]]::new()
    $unique = for ($i = $historyItems.Count - 1; $i -ge 0; $i--) {
        $cmd = $historyItems[$i].CommandLine
        if ($set.Add($cmd)) {
            $cmd
        }
    }
    return $unique
}

function Set-FzfHistoryKeybind {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Chord
    )

    # https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlinekeyhandler?view=powershell-7.4
    Set-PSReadLineKeyHandler -Chord $Chord -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        $matched = Invoke-FzfHistory $line
        if (!$matched) {
            return
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($matched)
    }
}

Set-FzfHistoryKeybind -Chord Ctrl+r





# --------------------------------------------------------------
# ----------------------LINUX FILE --------------------------
# --------------------------------------------------------------

Set-Alias bat batcat
Set-Alias ff fzf

$ENV:STARSHIP_CONFIG = "$HOME/.config/starship.toml"
Invoke-Expression (&starship init powershell)

function cheat {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$Command
    )
    Process {
        Invoke-RestMethod -Uri "https://cht.sh/$Command"
    }
}

function grep {
    & /usr/bin/grep --color=auto @Args
}

# Nala helpers
# Nala helpers - Only loaded if 'apt' is the package manager
if (Get-Command apt -ErrorAction SilentlyContinue) {
    function nalaup {
        sudo nala update
        if ($LASTEXITCODE -eq 0) {
            sudo nala upgrade
        }
    }

    function nalaupd {
        sudo nala update
    }

    function nalaupg {
        sudo nala upgrade
    }
}

# eza listing
function lss {
    eza -alh --color=auto --group-directories-first @Args
}

# ip with color
function ip {
    & /usr/sbin/ip --color=auto @Args
}


# & "C:\Users\marek\AppData\Local\Microsoft\WinGet\Links\eza.exe" -alh --smart-group --color=auto --group-directories-first --icons=auto

# i do not need to set fzf default options because it is loaded by `~/.bashrc` and when i open the pwsh after that it stays loaded

# --------------------------------------------------------------
# Copyright (C) 2024 Kenichi Kamiya

# Do not add --height option for fzf, it shows nothing in keybind use
function Invoke-FzfHistory ([String]$fuzzy) {
    $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems()
    $uniqueCommands = Get-UniqueReverseHistory $history
    # Join with NUL character to support multiline items in fzf
    # $matched = $uniqueCommands -join "`0" | fzf --read0 --no-sort --no-height --scheme=history --query=$fuzzy
    $matched = $uniqueCommands -join "`0" | fzf --read0 --layout reverse  --border --scheme=history --query=$fuzzy
    
    # fzf output is captured as a string array if it contains newlines.
    # Join them back with the current system newline.
    if ($matched) {
        return $matched -join [System.Environment]::NewLine
    }
}

# Internal helper to process history items: reverse and unique
function Get-UniqueReverseHistory ([Object[]]$historyItems) {
    $set = [System.Collections.Generic.HashSet[string]]::new()
    $unique = for ($i = $historyItems.Count - 1; $i -ge 0; $i--) {
        $cmd = $historyItems[$i].CommandLine
        if ($set.Add($cmd)) {
            $cmd
        }
    }
    return $unique
}

function Set-FzfHistoryKeybind {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Chord
    )

    # https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlinekeyhandler?view=powershell-7.4
    Set-PSReadLineKeyHandler -Chord $Chord -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        $matched = Invoke-FzfHistory $line
        if (!$matched) {
            return
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($matched)
    }
}

Set-FzfHistoryKeybind -Chord Ctrl+r
# --------------------------------------------------------------
