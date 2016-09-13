## Build Status
[![build status](https://gitlab.com/taylorgibb/powershell-modules/badges/master/build.svg)](https://gitlab.com/taylorgibb/powershell-modules/commits/master)

## Modules
* gibbels-common
* gibbels-algorithms

#### Common
The common module is a building block that houses code shared across higher level modules. You can import the module as follows:

```PowerShell
Install-Module -Name "gibbels-common"
Import-Module -Name "gibbels-common" -Scope CurrentUser
```

Supported cmdlets are:
* Get-DotNetVersions

#### Algorithms
The algorithms module contains a bunch of functions based on popular, or useful (in my opinion) algorithms. You can import the module as follows:

```PowerShell
Install-Module -Name "gibbels-algorithms"
Import-Module -Name "gibbels-algorithms" -Scope CurrentUser
```

Supported cmdlets are:
* Test-LuhnValidation
* Test-LevenshteinDistance