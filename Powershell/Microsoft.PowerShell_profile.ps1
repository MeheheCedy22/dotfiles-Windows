# Write-Host "------------ NEW POWERSHELL v7.x ------------"

# enable command history
Set-PSReadLineOption -PredictionSource History

# do not save wrong commands (when hit 'Enter' error pops up but from PSReadLine not the powershell itself)
Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine

# change to ListView instead of inline suggestion
Set-PSReadLineOption -PredictionViewStyle ListView

# for this to work need to install module (just once): Install-Module PSCompletions -Scope CurrentUser
# Import-Module PSCompletions

Set-Alias -Name "less" -Value "C:\Program Files\Git\usr\bin\less.exe"
Set-Alias -Name "grep" -Value "C:\Program Files\Git\usr\bin\grep.exe"
Set-Alias -Name "tail" -Value "C:\Program Files\Git\usr\bin\tail.exe"
Set-Alias -Name "head" -Value "C:\Program Files\Git\usr\bin\head.exe"
Set-Alias -Name "vim" -Value "C:\Program Files\Git\usr\bin\vim.exe"
Set-Alias -Name "touch" -Value "C:\Program Files\Git\usr\bin\touch.exe"
Set-Alias -Name "which" -Value "C:\Program Files\Git\usr\bin\which.exe"
Set-Alias -Name "wc" -Value "C:\Program Files\Git\usr\bin\wc.exe"

Set-Alias bb bat

$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
Invoke-Expression (&"C:\Program Files\starship\bin\starship.exe" init powershell)

# Get the parent (Alacritty) process of the current PowerShell process
$parent = Get-CimInstance Win32_Process -Filter "ProcessId = $((Get-CimInstance Win32_Process -Filter "ProcessId = $PID").ParentProcessId)"

# If it's Alacritty and doesn't have the --working-dir argument
if ($parent.Name -eq "alacritty.exe" -and $parent.CommandLine -notlike "*--working-dir*") {
    Set-Location "C:\Marek"
}

# Clear-Host

function cheat {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$Command
    )
    Process {
        Invoke-RestMethod -Uri "https://cht.sh/$Command"
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
            & "C:\Users\marek\AppData\Local\Microsoft\WinGet\Links\eza.exe" -alh --group-directories-first --absolute=on $finalParams
        }
        else
        {
            & "C:\Users\marek\AppData\Local\Microsoft\WinGet\Links\eza.exe" -alh --group-directories-first $finalParams
        }
    }
}

function ff {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$params
    )

    process {
        # ne -> not equal
        # if there is some piped input, than use it as piped input (cant have params / do not need params)
        if ($_ -ne $NULL)
        {
            foreach ($var in $_)
            {
                $inputData += $var.ToString() + "`n"
            }
        }
    }

    end {
        # remove color escape chars
        # $inputData = $inputData -replace '\x1b\[[0-9;]*[mK]', ''
        # remove last endline
        $inputData = $inputData -replace "(\r?\n)$", ""

        if ($_ -ne $NULL)
        {
            $inputData | & "C:\Users\marek\AppData\Local\Microsoft\WinGet\Links\fzf.exe" --height 75% --layout reverse --multi --border --preview 'bat --color=always {}'
        } 
        else {
            # else -> there is no piped input, can use additional params
            & "C:\Users\marek\AppData\Local\Microsoft\WinGet\Links\fzf.exe" --height 75% --layout reverse --multi --border --preview 'bat --color=always {}' $params
        }
    }
}