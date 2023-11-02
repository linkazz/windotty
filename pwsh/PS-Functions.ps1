<#====================================================================
@ Powershell 
====================================================================#>

# add details to tab completion values for get-service
$s = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $services = Get-Service | Where-Object {$_.Status -eq "Running" -and $_.Name -like "$wordToComplete*"}
    $services | ForEach-Object {
        New-Object -Type System.Management.Automation.CompletionResult -ArgumentList $_.Name,
        $_.Name,
        "ParameterValue",
        $_.Name
    }
}
Register-ArgumentCompleter -CommandName Stop-Service -ParameterName Name -ScriptBlock $s

function Get-Weather()
{
    Invoke-RestMethod 'https://wttr.in?format=🌡️ %t (Feels like %f) %c(%C) 💧%h (humidity) 💨 %w ☂️  %p'
    Invoke-RestMethod 'https://wttr.in?format=🌄 %D 🔅 %S 🎇 %z 🌆 %s 🌃 %d %m \n'
}

<#====================================================================
@ Navigation
====================================================================#>
# w/o modified/accessed date
$opts = @(
    "-al",
    "--group-directories-first",
    "--colour=always",
    "--icons=always",
    "--color-scale",
    "--hyperlink",
    "--width=120",
    "--no-time",
    "--no-filesize",
    "-s=name",
    "-s=type",
    "-s=Extension"
)

Function list_single_all
{
    eza.exe @opts $args
}
Remove-Alias ls
Set-Alias -Name ls -Value list_single_all
# open in explorer
function xr()
{
    explorer $args
}

function dev
{ 
    Set-Location ~/Projects 
}

function dev2
{ 
    Set-Location -Path G:\programming\projects 
}

function conf
{
    Set-Location ~/.config 
}

function pwshconf
{
    Set-Location -Path "$HOME/.config/pwsh" 
}
<#====================================================================
@ Hashes
====================================================================#>
# Compute file hashes - useful for checking successful downloads 
function md5
{ Get-FileHash -Algorithm MD5 $args 
}
function sha1
{ Get-FileHash -Algorithm SHA1 $args 
}
function sha256
{ Get-FileHash -Algorithm SHA256 $args 
}

<#====================================================================
@ Unix
====================================================================#>

function Test-CommandExists
{
    Param(
        $command
    )
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try
    { if (Get-Command $command)
        { RETURN $true 
        } 
    } Catch
    { Write-Host "$command does not exist"; RETURN $false 
    } Finally
    { $ErrorActionPreference = $oldPreference 
    }
}

#ENV:EDITOR
if (Test-CommandExists nvim)
{
    $EDITOR='nvim'
} elseif (Test-CommandExists vim)
{
    $EDITOR='vim'
} elseif (Test-CommandExists pvim)
{
    $EDITOR='pvim'
} elseif (Test-CommandExists code)
{
    $EDITOR='code'
} elseif (Test-CommandExists notepad++)
{
    $EDITOR='npp'
} 
Set-Alias -Name vim -Value $EDITOR

Function touch 
{
    New-Item $args && nvim $args

}

# sudo
function sudo()
{
    Invoke-Elevated $args
}

# symlink 
function newLink ($target, $link)
{
    New-Item -ItemType SymbolicLink -Path $link -Value $target
}
set-alias ln newLink

# export
function export($name, $value)
{
    set-item -force -path "env:$name" -value $value;
}

# fuser - looks any process running in the folder/subdirectories
function fuser($relativeFile)
{
    $file = Resolve-Path $relativeFile
    foreach ( $Process in (Get-Process))
    {
        foreach ( $Module in $Process.Modules)
        {
            if ( $Module.FileName -like "$file*" )
            {
                $Process | Select-Object id, path
            }
        }
    }
}

#recursive sed
function edit-recursive($filePattern, $find, $replace)
{
    $files = get-childitem . "$filePattern" -rec # -Exclude
    write-output $files
    foreach ($file in $files)
    {
  (Get-Content $file.PSPath) |
            Foreach-Object { $_ -replace "$find", "$replace" } |
            Set-Content $file.PSPath
    }
}

function which ($command)
{
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

<#====================================================================
@ OS MANAGEMENT & MAINTENANCE 
====================================================================#>

function reboot
{
    shutdown /r /t 0
}

# create directory and cd
function mk()
{
    $directoryName = $args -join ' '
    mkdir -p $directoryName
    Set-Location $directoryName
}

# remove files/folder
function rmf()
{
    Remove-Item -Force $args
}

<#====================================================================
@ CUSTOM FUNCTIONS & PLUGINS
====================================================================#>

# preview files in directory with fzf 
function fzfb
{
    fzf --multi --height=50% --margin=2%,2%,2%,2% --layout=reverse-list --border=double --info=inline --ansi --cycle --pointer='→' --marker='☆' --header='CTRL-c or ESC to quit' --preview 'bat {}' $args
}

function Invoke-FuzzyDirectory
{
    Get-ChildItem . -Directory | Invoke-Fzf -Multi -Cycle -Layout reverse-list -Height 50 -Border double -Info inline -Ansi  -Pointer '→' -Marker '☆' -Header "CTRL-C or ESC to Quit" -Preview 'bat {}'
}

function Invoke-FuzzyEdit()
{
    $files = fzfb 

    $editor = $env:EDITOR
    if ($editor -eq $null)
    {
        if ($IsWindows)
        {
            $editor = 'nvim'
        } else
        {
            $editor = 'code'
        }
    }
    if ($files -ne $null)
    {
        Invoke-Expression -Command ("$editor {0}" -f ($files -join ' ')) 
    }
}
Set-Alias -Name fe -Value Invoke-FuzzyEdit

# magic-wormhole
function whs
{
    wormhole send $args
}
function whr
{
    wormhole receive $args
}

