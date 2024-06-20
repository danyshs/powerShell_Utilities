##### OH MY POSH ####
function Set-EnvVar {
    $env:POSH=$(Get-Date)
}

New-Alias -Name 'Set-PoshContext' -Value 'Set-EnvVar' -Scope Global -Force
oh-my-posh init pwsh --config "C:\Users\danys\Downloads\purple-man.json" | Invoke-Expression

##### OH MY POSH ####