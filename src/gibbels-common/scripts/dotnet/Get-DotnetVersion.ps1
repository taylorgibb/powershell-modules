class DotNetVersion
{
    [string]$Name;
    [string]$Profile;
    [version]$Version;
    [string]$ServicePack;

    DotNetVersion([string]$name, [string]$profile, [version]$version, [string]$servicePack){
       $this.Name = $name;
       $this.Profile = $profile;
       $this.Version = $version;
       $this.ServicePack = $servicePack;
    }
}

function Get-DotNetVersionString {
   
   param
   (
        [ValidatePattern("^[0-9]")]
        [Parameter(Mandatory=$true)]
        [string]$VersionString
   )

   if($VersionString.Contains(".")){
    return ".Net Framework v$($VersionString.Substring(0,3).TrimEnd(".0"))";
   }
   return ".Net Framework v$($VersionString.TrimEnd(".0"))";
} 

<# 
 .Synopsis
  Checks which versions of .Net are currently installed

.Description
  Uses the registry to determine which versions of .Net are installed

.Example
  Get-DotNetVersion
#>
function Get-DotNetVersion {

    $keys = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\"
    foreach($key in $keys) {
        $name = $key.Name.Split("\")[-1]
        if($name -like "v*") {
           $version = $key.GetValue("Version", "");
           if($key.GetValue("Install", "") -eq "1"){
            [DotNetVersion]::new($(Get-DotNetVersionString $version), "N/A", [version]$version, $key.GetValue("SP", ""));
           }
           if($version -ne ""){
            continue;
           }
           foreach($subkeyName in $key.GetSubKeyNames()){
             $subkey = $key.OpenSubKey($subkeyName);
             $install = $subkey.GetValue("Install", "");
             $version = $subkey.GetValue("Version", "")
             $servicePack = $subkey.GetValue("SP", "N/A")
             if($install -eq "1"){
                [DotNetVersion]::new($(Get-DotNetVersionString $version), $subkeyName, [version]$version, $servicePack);
             }
           }
        }
    }
}
