Remove-Alias ls
Set-Alias ls list_all
Set-Alias -Name cat -Value bat
Set-Alias trash Remove-ItemSafely
# waifu-2x
Set-Alias waifu waifu2x-ncnn-vulkan
Set-Alias -Name upman -Value Update-All-Help
Set-Alias -Name tp -Value Test-Password
Set-Alias -Name omp -Value Oh-My-Posh.exe

function Update-All-Help
{
    Update-Help * -Ea 0 -Force -Verbose
}

function ..
{
    Set-Location ..
}

function ....
{
    Set-Location ../..
}

function ......
{
    Set-Location ../../..
}

function ~
{
    Set-Location $HOME
}

function refresh
{
    refreshenv
    Invoke-Expression -Command $PROFILE
    Write-Host -ForegroundColor Green "Refreshed: $ENV:USERNAME"
}

function stm
{
    $MenuConfig = "C:\Users\linka\.config\pwsh\MenuConfig.xml"
    Show-Treemenu -XmlPath $MenuConfig
}

