Import-Module $([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSCommandPath, '..\..\..\gibbels-algorithms.psd1')));

Describe "Test-LuhnValidation" {
  Context "Given a Visa credit card (4024007106418766)" {
      $result = Test-LuhnValidation -Number 4024007106418766
      It "Should pass validation" {
          $result | Should Be $true
      }
    }
}

Describe "Test-LuhnValidation" {
  Context "Given a American Express credit card (374519847840029)" {
      $result = Test-LuhnValidation -Number 374519847840029
      It "Should pass validation" {
          $result | Should Be $true
      }
    }
}

Describe "Test-LuhnValidation" {
  Context "Given a Mastercard credit card (5353760959262719)" {
      $result = Test-LuhnValidation -Number 5353760959262719
      It "Should pass validation" {
          $result | Should Be $true
      }
    }
}

