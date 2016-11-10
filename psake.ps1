properties {
    $scripts = "$PSScriptRoot\src\"
}

task Check -depends Analyze, Test 
task Release -depends Check 

task Analyze {
     $result = Invoke-ScriptAnalyzer -Path $scripts -Severity @('Error', 'Warning') -Recurse
     if ($result) {
        $result | Format-Table  
        Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'        
     }
}

task Test {
    Invoke-Pester -Path $scripts -EnableExit
}

task Release {
    Invoke-PSDeploy -Recurse
}