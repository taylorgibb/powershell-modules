function Test-LuhnValidation(){
      [CmdletBinding()]
    param([string]$Number)
   
    if(($Number.Length % 2) -ne 0)
    {
        $Number = $Number.Insert(0, 0)
    }
    
    $Length = $Number.Length
    $Regex = "(\d)" * $Length
    
    if($Number -match $Regex)
    {
        $Sum = 0
        $OrigMatches = $Matches
    
        for($i = 1; $i -lt $OrigMatches.Count; $i++)
        {
            if(($i % 2) -ne 0)
            {
                $digit = ([int]::Parse($OrigMatches[$i]) * 2)
                if($digit.ToString() -match '(\d)(\d)')
                {
                   $digit = [int]::Parse($Matches[1]) + [int]::Parse($Matches[2])
                }
            }
            else 
            {
                $digit = [int]::Parse($OrigMatches[$i])
            }
            $Sum += $digit
        }
        if(($Sum % 10) -eq 0)
        {
          return $True
        }
        else
        {
           return $False
        }
    }
    else
    {
        Write-Host "Please Check Your Input"
    }
}