Import-Module $([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSCommandPath, '..\..\..\gibbels-algorithms.psd1')));

Describe "Luhn Validation" {
  Context "Given VISA credit card number" {
      $result = Test-LuhnValidation -Number 4288667983082851
      It "Should pass Luhn Validation" {
          $result | Should Be $true
      }
    }
}