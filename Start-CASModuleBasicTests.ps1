

If (Get-Module Cloud-App-Security) {Remove-Module Cloud-App-Security}
$ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Import-Module "$ScriptPath\Cloud-App-Security.psm1"

$CASCredential = Import-Clixml C:\Users\jpoeppel\mod102677.credential

Function Test-ForErrors
{
    [CmdletBinding()]
    Param
    (
        $Block
    )
    Process
    {
        Try 
        {
            Write-Verbose "Running test: $Block"
            &$Block | Out-Null
        } 
        Catch 
        {
            #Write-Error "$Block encountered. The error was: $Error"
            Write-Output (New-Object -TypeName PSObject -Property @{TestItem=$Block;Result=$Error})
        }
        If ($Error) {Write-Verbose 'ERROR'} Else {Write-Verbose 'SUCCESS'}
        $Error.Clear()
    }
 }    

# Initialize
$ErrorAction = 'SilentlyContinue'
$SuccessTests = @()
$SuccessTestResults = @()
$FailureTests = @()
$FailureTestResults = @()
$OverallSuccess = $true



#region ---------- Success Tests ----------
$SuccessTests += {Get-CASAccount -ResultSetSize 1}
$SuccessTests += {Get-CASAccount -ResultSetSize 2}
$SuccessTests += {Get-CASAccount -ResultSetSize 1 | Get-CASAccount}
$SuccessTests += {Get-CASAccount -ResultSetSize 2 | Get-CASAccount}
$SuccessTests += {Get-CASAccount -ResultSetSize 4999}
$SuccessTests += {Get-CASAccount -ResultSetSize 5000}
$SuccessTests += {Get-CASAccount -ResultSetSize 1 -Skip 5000}
$SuccessTests += {Get-CASAccount -External $true}
$SuccessTests += {Get-CASAccount -External $false}
$SuccessTests += {Get-CASAccount -UserName 'bogus@contoso.invalid'}
$SuccessTests += {Get-CASAccount -UserName 'bogus@contoso.com','bogus2@tailspintoys.example'}
$SuccessTests += {Get-CASAccount -Services 20595}
$SuccessTests += {Get-CASAccount -Services 20595,11161}
$SuccessTests += {Get-CASAccount -ServiceNames 'Microsoft Cloud App Security'}
$SuccessTests += {Get-CASAccount -ServiceNames 'Microsoft Cloud App Security','Office 365'}
$SuccessTests += {Get-CASAccount -ServicesNot 11161}
$SuccessTests += {Get-CASAccount -ServicesNot 11161,11770}
$SuccessTests += {Get-CASAccount -ServiceNamesNot 'Office 365'}
$SuccessTests += {Get-CASAccount -ServiceNamesNot 'Office 365','Google Apps'}
$SuccessTests += {Get-CASAccount -UserDomain 'contoso.com'}
$SuccessTests += {Get-CASAccount -UserDomain 'contoso.com','tailspintoys.example'}
$SuccessTests += {Get-CASAccount -ResultSetSize 5 -SortBy UserName -SortDirection Ascending}
$SuccessTests += {Get-CASAccount -ResultSetSize 5 -SortBy LastSeen -SortDirection Descending}

$SuccessTests += {Get-CASActivity -ResultSetSize 1}
$SuccessTests += {Get-CASActivity -ResultSetSize 2}
$SuccessTests += {Get-CASActivity -ResultSetSize 1 | Get-CASActivity}
$SuccessTests += {Get-CASActivity -ResultSetSize 2 | Get-CASActivity}
$SuccessTests += {Get-CASActivity -ResultSetSize 9999}
$SuccessTests += {Get-CASActivity -ResultSetSize 10000}
$SuccessTests += {Get-CASActivity -ResultSetSize 1 -Skip 10000}
$SuccessTests += {Get-CASActivity -AdminEvents $true}
$SuccessTests += {Get-CASActivity -AdminEvents $false}

$SuccessTests += {Get-CASAlert -ResultSetSize 1}
$SuccessTests += {Get-CASAlert -ResultSetSize 2}
$SuccessTests += {Get-CASAlert -ResultSetSize 1 | Get-CASAlert}
$SuccessTests += {Get-CASAlert -ResultSetSize 2 | Get-CASAlert}
$SuccessTests += {Get-CASAlert -ResultSetSize 9999}
$SuccessTests += {Get-CASAlert -ResultSetSize 10000}
$SuccessTests += {Get-CASAlert -ResultSetSize 1 -Skip 10000}

$SuccessTests += {Get-CASFile -ResultSetSize 1}
$SuccessTests += {Get-CASFile -ResultSetSize 2}
$SuccessTests += {Get-CASFile -ResultSetSize 1 | Get-CASFile}
$SuccessTests += {Get-CASFile -ResultSetSize 2 | Get-CASFile}
$SuccessTests += {Get-CASFile -ResultSetSize 4999}
$SuccessTests += {Get-CASFile -ResultSetSize 5000}
$SuccessTests += {Get-CASFile -ResultSetSize 1 -Skip 5000}
#endregion ---------- Success Tests ----------#>



#region ---------- Failure Tests ----------
$FailureTests += {Get-CASAccount -ResultSetSize -1}
$FailureTests += {Get-CASAccount -ResultSetSize 0}
$FailureTests += {Get-CASAccount -ResultSetSize 5001}
$FailureTests += {Get-CASAccount -ServiceNames 'Invalid'}
$FailureTests += {Get-CASAccount -ServiceNamesNot 'Invalid'}
$FailureTests += {Get-CASAccount -SortBy 'Invalid' -SortDirection 'Ascending'}
$FailureTests += {Get-CASAccount -SortBy 'UserName' -SortDirection 'Invalid'}

$FailureTests += {Get-CASActivity -ResultSetSize -1}
$FailureTests += {Get-CASActivity -ResultSetSize 0}
$FailureTests += {Get-CASActivity -ResultSetSize 10001}

$FailureTests += {Get-CASAlert -ResultSetSize -1}
$FailureTests += {Get-CASAlert -ResultSetSize 0}
$FailureTests += {Get-CASAlert -ResultSetSize 10001}

$FailureTests += {Get-CASFile -ResultSetSize -1}
$FailureTests += {Get-CASFile -ResultSetSize 0}
$FailureTests += {Get-CASFile -ResultSetSize 5001}
#endregion ---------- Failure Tests ----------#>



#Get-CASAccount -ServiceNames 'Microsoft Cloud App Security' | FT


$SuccessTestResults += $SuccessTests | ForEach {Test-ForErrors $_ -Verbose}
If ($SuccessTestResults.Count -ne 0)
{
    $OverallSuccess = $false
    Write-Warning ("Testing found "+$SuccessTestResults.Count+" unexpected errors in success tests:")
    $SuccessTestResults | FT TestItem,Result
} 

$FailureTestResults += $FailureTests | ForEach {Test-ForErrors $_ -Verbose}
If ($FailureTestResults.Count -ne $FailureTests.Count)
{
    $OverallSuccess = $false
    Write-Warning ("Testing only found "+$FailureTestResults.Count+" errors when "+$FailureTests.Count+" errors were expected:")
    $FailureTestResults | FT TestItem,Result
} 

Write-Output $OverallSuccess

Read-Host -Prompt 'Testing complete, press Enter to close'