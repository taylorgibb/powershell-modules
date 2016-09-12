<#
.SYNOPSIS
 Checks whether a given Input was generated using the Luhn algorithm.

.PARAMETER Number
 The number you want to validate.

.EXAMPLE
 Test-LuhnValidation -Number "79927398712"
#>
function Test-LuhnValidation(){
    
    [CmdletBinding()]
    param (

        [string]$Number
    )
    
    if(!$($Number.Length % 2 -eq 0)){
        $Number.Insert(0,0);  
    }

    $sum = 0;
    $alt = $true;
    $temp = $Number.ToCharArray();
    $numbers = @(0) * $Number.Length;

    for($i = 0; $i -lt $numbers.Length; $i++){
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