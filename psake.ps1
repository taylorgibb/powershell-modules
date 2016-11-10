properties {
    $scripts = "$PSScriptRoot\src\"
}

task Analyze {
     $result = Invoke-ScriptAnalyzer -Path $scripts -Severity @('Error', 'Warning') -Recurse
     if ($result) {
        $result | Format-Table  
        Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'        
     }
}

task Test -depends Analyze {
    Invoke-Pester -Path $scripts -EnableExit
}

task Release -depends Test {
    try {
        Invoke-PSDeploy -Force 
    }
    catch {
       Write-Error 'Deployment failed';
       Throw $_;
       Exit 1;
    }
}