properties {
    $scripts = "$PSScriptRoot\src\"
}

task Analysis {
     $result = Invoke-ScriptAnalyzer -Path $scripts -Severity @('Error', 'Warning') -Recurse
     if ($result) {
        $result | Format-Table  
        Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'        
     }
}

task Test -depends Analysis {
    Invoke-Pester -Path $scripts -EnableExit
}

task Release {
    try {
        Invoke-PSDeploy -Force 
    }
    catch {
       Write-Output $_.Exception.Message
       EXIT 1
    }
}