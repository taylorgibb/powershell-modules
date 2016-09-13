Import-Module $([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSCommandPath, '..\..\..\gibbels-algorithms.psd1')));

Describe "Test-LevenshteinDistance" {
  Context "Given a source of 'Taylor Gibb' and target of 'Taylor'" {
      $source = 'Taylor Gibb'
      $target = 'Taylor'
      $result = Test-LevenshteinDistance -Source $source -Target $target
      It "Should return a distance of 5" {
          $result | Should Be 5
      }
    }
}