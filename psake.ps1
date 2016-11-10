properties {
    $scripts = "$PSScriptRoot\src\"
}

task default -depends Analyze, Test 

task Analyze {
     $result = Invoke-ScriptAnalyzer -Path $scripts -Severity @('Error', 'Warning') -Recurse
     if ($result) {
        $result | Format-Table  
        Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'        
     }
}

task Test {
    Invoke-Pester -Path $scripts -PassThru -EnableExit
}