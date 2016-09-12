<#
.SYNOPSIS
    Sync's a local folder with a Azure Storage account.
.DESCRIPTION
    Sync's a local folder with a Azure Storage account using MD5 hashes.
.PARAMETER Share
    The Azure Storage file share name you wish to sync your local folder with.
.PARAMETER LocalPath
    The local folder you wish to sync with the Azure Storage file share.
.PARAMETER StorageAccountName
    The name of the Azure Storage account that houses your file share.
.PARAMETER StorageAccountKey
    The Azure Storage account key.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Taylor Gibb
  Creation Date:  15/06/2016
  Purpose/Change: Initial script development
.EXAMPLE
  Sync-AzureFileStorage -Share "scripts" -LocalPath "C:\Users\taylorg\Desktop\sync\data" -StorageAccountName "developerhut" -StorageAccountKey "34ZM8+ixpJgoBk9PWZniGWowkOGfHKCtdrIOOPXfEDFGYu6Xx0c93F1AZCFLr9lQvaQX2z2DVCagOGS8qS59d3w=="
#>
function Sync-AzureFileStorage {

    #Requires -Version 4
    param(
        [Parameter(Mandatory=$True)]
        [string]$Share,
        [Parameter(Mandatory=$True)]
        [string]$LocalPath,
        [Parameter(Mandatory=$True)]
        [string]$StorageAccountName,
        [Parameter(Mandatory=$True)]
        [string]$StorageAccountKey
    )
    
    $Context =  New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $RemoteFiles = Get-AzureStorageFile -ShareName $Share -Context $Context 
    $LocalFiles = Get-ChildItem -LiteralPath $LocalPath -File | Where-Object {$_.Length -gt 0}
    
    if($LocalFiles.Length -eq 0) {
      $RemoteFiles | Remove-AzureStorageFile -Confirm:$false
    }
    elseif($RemoteFiles -eq $null) {
        $LocalFiles | Set-AzureStorageFileContent -ShareName $Share -Context $Context
    }
    else{
        $Diff = Compare-Object -ReferenceObject $($LocalFiles | Select-Object -ExpandProperty Name) -DifferenceObject $($RemoteFiles | Select-Object -ExpandProperty Name) -IncludeEqual
        foreach($Result in $Diff)
        {
            if($Result.SideIndicator -eq "=>"){
                Write-Host "Deleting $($Result.InputObject)"
                Remove-AzureStorageFile -ShareName $Share -Path $Result.InputObject -Context $Context -Confirm:$false
                continue;
            }
        
            if($Result.SideIndicator -eq "<="){
                 Write-Host "Uploading $($Result.InputObject)"
                 Set-AzureStorageFileContent -ShareName $Share -Source $(Join-Path -Path $LocalPath -ChildPath $Result.InputObject) -Context $Context 
                 continue;
            }
    
            $LocalFileHash = Get-FileHash -Path $(Join-Path -Path $LocalPath -ChildPath $Result.InputObject) -Algorithm MD5
            $TempPath = [System.IO.Path]::GetTempFileName();
            $RemoteFile = Get-AzureStorageFileContent -ShareName $Share -Path $Result.InputObject -Context $Context -Destination $TempPath -Confirm:$false
            $RemoteFileHash = Get-FileHash -Path $TempPath -Algorithm MD5
            if($LocalFileHash.Hash -ne $RemoteFileHash.Hash){
                Remove-AzureStorageFile -ShareName $Share -Path $Result.InputObject -Context $Context -Confirm:$false
                Set-AzureStorageFileContent -ShareName $Share -Source $(Join-Path -Path $LocalPath -ChildPath $Result.InputObject) -Context $Context 
            }
            Remove-Item -Path $TempPath -Force
        }
    }
}