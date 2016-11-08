<#
 .SYNOPSIS
  Checks whether a given number was generated using the Luhn algorithm.
 
 .PARAMETER Number
  The number you want to validate.
 
 .EXAMPLE
  Test-LuhnValidation -Number "79927398712"
#>
function Test-LuhnValidation {

    param (
        [Parameter(Mandatory=$True)]
        [string]$Number
    )
    
    $temp = $Number.ToCharArray();
    $numbers = @(0) * $Number.Length;
    $alt = $false;

    for($i = $temp.Length -1; $i -ge 0; $i--) {
       $numbers[$i] = [int]::Parse($temp[$i])
       if($alt){
           $numbers[$i] *= 2
           if($numbers[$i] -gt 9) { 
               $numbers[$i] -= 9 
           }
       }
       $sum += $numbers[$i]
       $alt = !$alt
    }
    return ($sum % 10) -eq 0
}

