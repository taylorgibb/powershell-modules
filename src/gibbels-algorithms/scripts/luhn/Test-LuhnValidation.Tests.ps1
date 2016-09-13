Import-Module $([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSCommandPath, '..\..\..\gibbels-algorithms.psd1')));

Describe "Test-LuhnValidation" {
  Context "Given a credit card number" {
      $result = Test-LuhnValidation -Number 4288667983082851
      It "Should pass validation" {
          $result | Should Be $true
      }
    }
}