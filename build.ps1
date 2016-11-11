param(
    [string[]]$Tasks
)

function Install-Dependencies
{
    $policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
    if($policy -ne "Trusted") {
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    }
    
    if (!(Get-Module -Name psake -ListAvailable)) { 
        Install-Module -Name psake -Scope CurrentUser 
    }
    
    if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { 
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser 
    }
    
    if (!(Get-Module -Name Pester -ListAvailable)) { 
        Install-Module -Name Pester -Scope CurrentUser 
    }
    
    if (!(Get-Module -Name PSDeploy -ListAvailable)) { 
        Install-Module -Name PSDeploy -Scope CurrentUser 
    }
}

function Analyze-Scripts
{
    param(
        [string]$Path = "$PSScriptRoot\src\"
    )
    Write-Output "Analyzing Scripts..."
    $result = Invoke-ScriptAnalyzer -Path $Path -Severity @('Error', 'Warning') -Recurse
    if ($result) {
       $result | Format-Table  
       Write-Error -Message 'One or more Script Analyzer errors or warnings were found.'   
       EXIT 1     
    }
}

function Run-Tests
{
    param(
        [string]$Path = "$PSScriptRoot\src\"
    )
    Write-Output "Running Pester Tests..."
    Invoke-Pester -Path $Path -Quiet
}

function Deploy-Modules
{
    try {
       if($(Get-GitCommitMessage) -like "[deploy]") {
          Write-Output "Deploying Modules..."
          Invoke-PSDeploy -Force 
       }
       else {
          Write-Output "Skipping Deploy..."
       }
    }
    catch {
       Write-Output $_.Exception.Message
      # EXIT 1
    }
}

function Get-GitCommitMessage
{
    git log -1 --pretty=%B
}

Install-Dependencies

foreach($task in $Tasks){
    switch($task)
    {
        "analyze" {
            Analyze-Scripts
        }
        "test" {
            Run-Tests
        }
        "release" {
            Deploy-Modules
        }
    }
}
