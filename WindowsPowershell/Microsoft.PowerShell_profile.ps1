# Write-Host "------------ OLD WINDOWS POWERSHELL (< v5.x) ------------"

# enable command history
Set-PSReadLineOption -PredictionSource History

# do not save wrong commands (when hit 'Enter' error pops up but from PSReadLine not the powershell itself)
Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine

# change to ListView instead of inline suggestion
Set-PSReadLineOption -PredictionViewStyle ListView

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
            # Write-Error "No argument provided."
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

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
