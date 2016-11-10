param(
    [string[]]$Task = 'default'
)


if (!(Get-Module -Name psake -ListAvailable)) { 
    Install-Module -Name psake -Scope CurrentUser 
}
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { 
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser 
}
if (!(Get-Module -Name Pester -ListAvailable)) { 
    Install-Module -Name Pester -Scope CurrentUser 
}

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task
