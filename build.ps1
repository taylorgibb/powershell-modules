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
    $result = Invoke-ScriptAnalyzer -Path $Path -Severity @('Error', 'Warning') -Recurse
    if ($result) {
       $result | Format-Table  
       Write-Error -Message "$($result.SuggestedCorrections.Count) linting errors or warnings were found. The build cannot continue."
       EXIT 1     
    }
}

function Run-Tests
{
    param(
        [string]$Path = "$PSScriptRoot\src"
    )
     
    $results = Invoke-Pester -Path $Path -CodeCoverage $Path\*\*\*\*.ps1 -PassThru -Quiet
    if($results.FailedCount -gt 0) {
       Write-Output "$($results.FailedCount) tests failed. The build cannot continue."
       EXIT 1
    }
    $coverage = [math]::Round($(100 - (($results.CodeCoverage.NumberOfCommandsMissed / $results.CodeCoverage.NumberOfCommandsAnalyzed) * 100)), 2);
    Write-Output "Code Coverage: $coverage%"
}

function Deploy-Modules
{
    try {
       Invoke-PSDeploy -Force 
    }
    catch {
       Write-Output $_.Exception.Message
       EXIT 1
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
            Write-Output "Analyzing Scripts..."
            Analyze-Scripts
        }
        "test" {
            Write-Output "Running Pester Tests..."
            Run-Tests
        }
        "release" {
            $message = Get-GitCommitMessage
            if($message.ToLower().Contains("[deploy]")) {
                Write-Output "Deploying Modules..."
                Deploy-Modules
            }
            else {
                Write-Output "Skipping Deploy..."
            }
        }
    }
}
