
oh-my-posh init pwsh --config "C:\Users\linka\.config\ohmyposh\ys-splinks.omp.json" | Invoke-Expression

# import pwsh modules
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
    Import-Module TabExpansionPlusPlus
    Import-Module "gsudoModule"
    Import-Module Terminal-Icons
    Import-Module PSFzf
    Import-Module ZLocation
    Import-Module Pscx
    # Import-Module DynamicTitle
    Import-Module Catppuccin
}

$Flavor = $Catppuccin['Mocha']

# choco tab completions
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}

# source .ps1 files
$scriptFiles = Get-ChildItem -Path "$HOME\.config\pwsh" -Filter "*.ps1"
foreach ($file in $scriptFiles)
{
    . $file.FullName
}

# completions
$completionsFiles = Get-ChildItem -Path "$HOME\.config\pwsh\completions" -Filter "*.ps1"
foreach ($completions in $completionsFiles)
{
    . $completions.FullName
}

# environment variables
$env:XDG_CONFIG_HOME = "$HOME\.config"
$env:BAT_CONFIG_PATH = "$HOME\.config\bat\config"
$env:SYSINT = "C:\Program Files (x86)\SysInterals Suit"    
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
# $MaximumHistoryCount = 10000;

# psreadline options
$OnViModeChange = [scriptblock]{
    if ($args[0] -eq 'Command')
    {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else
    {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

$PSReadLineOptions = @{
    EditMode = "Vi"
    ViModeIndicator = "Script"
    ViModeChangeHandler = $OnViModeChange 
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    PredictionSource = "HistoryAndPlugin"
    PredictionViewStyle = "ListView"
    BellStyle = "Visual"
    Colors = @{
        InlinePrediction = $Flavor.Overlay0.Foreground()
        Emphasis = $Flavor.Red.Foreground()
        ContinuationPrompt = $Flavor.Teal.Foreground()
        Error = $Flavor.Red.Foreground()
        Selection = $Flavor.Surface0.Background()
        Default = $Flavor.Text.Foreground()
        Comment = $Flavor.Overlay0.Foreground()
        Keyword = $Flavor.Mauve.Foreground()
        String = $Flavor.Green.Foreground()
        Operator = $Flavor.Sky.Foreground()
        Variable = $Flavor.Lavender.Foreground()
        Command = $Flavor.Blue.Foreground()
        Parameter = $Flavor.Pink.Foreground()
        Type = $Flavor.Yellow.Foreground()
        Number = $Flavor.Peach.Foreground()
        Member = $Flavor.Rosewater.Foreground()
        ListPrediction = $Flavor.Mauve.Foreground() 
        ListPredictionSelected = $Flavor.Surface0.Background()
    }
}
Set-PSReadLineOption @PSReadLineOptions

$env:FZF_DEFAULT_OPTS = @"
--multi
--height=50%
--layout=reverse-list
--margin=2%,2%,2%,2%
--ansi
--border=double
--info=inline
--cycle
--scroll-off=4
--pointer='→' 
--marker='☆'
--header='CTRL-C or ESC to quit'
--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
--preview 'bat --style=numbers --color=always {}'
"@
$env:FZF_DEFAULT_COMMAND= "fd --type f --hidden --follow --exclude .git --color=always"
$env:FZF_CTRL_T_COMMAND=$env:FZF_DEFAULT_COMMAND
$env:_PSFZF_FZF_DEFAULT_OPTS=$env:FZF_DEFAULT_OPTS
# $env:FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git --color=always"

# $FZF_ALT_C_COMMAND = [scriptblock]{
#     Invoke-Expression "fd --type d --hidden --follow --exclude .git --color=always"
# }

$PsFzfOptions = @{
    TabExpansion = $true
    PSReadlineChordProvider = 'Ctrl+t'
    PSReadlineChordReverseHistory = 'Ctrl+r'
    # PSReadlineChordSetLocation = ''
    # PSReadlineChordReverseHistoryArgs = ''
    # GitKeyBindings = $true
    EnableAliasFuzzyEdit = $true
    # EnableAliasFuzzyFasd = $true #ff (fasdr)
    EnableAliasFuzzyHistory = $true #fh
    # EnableAliasFuzzySetLocation = $true #fd
    # EnableAliasFuzzySetEverything = $true #cde
    EnableAliasFuzzyZLocation = $true
    EnableAliasFuzzyKillProcess = $true
    EnableAliasFuzzyScoop = $true
    # EnableAliasFuzzyGitStatus = $true #fgs
    EnableFd = $true
    AltCCommand = $commandOverride
}
Set-PsFzfOption @PsFzfOptions

$commandOverride = [ScriptBlock]{ param($FZF_ALT_C_COMMAND) Write-Host $FZF_ALT_C_COMMAND }
# Set-PsFzfOption -AltCCommand $commandOverride

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function ShowParameterHelp
Set-PSReadLineKeyHandler -Chord 'Ctrl+m' -Function SelectCommandArgument

Clear-Host
# END <<======================================================================================
