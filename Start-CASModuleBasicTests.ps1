
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
    }
 }    

# Initialize
$ErrorAction = 'SilentlyContinue'
$SuccessTests = @()
$SuccessTestResults = @()
$FailureTests = @()
$FailureTestResults = @()
$OverallSuccess = $false

#region ---------- Success Tests ----------

$SuccessTests += {Get-CASAccount -ResultSetSize 1}
$SuccessTests += {Get-CASAccount -ResultSetSize 2}
$SuccessTests += {Get-CASAccount -ResultSetSize 1 | Get-CASAccount}
$SuccessTests += {Get-CASAccount -ResultSetSize 2 | Get-CASAccount}
$SuccessTests += {Get-CASAccount -ResultSetSize 4999}
$SuccessTests += {Get-CASAccount -ResultSetSize 5000}

$SuccessTests += {Get-CASActivity -ResultSetSize 1}
$SuccessTests += {Get-CASActivity -ResultSetSize 2}
$SuccessTests += {Get-CASActivity -ResultSetSize 1 | Get-CASActivity}
$SuccessTests += {Get-CASActivity -ResultSetSize 2 | Get-CASActivity}
$SuccessTests += {Get-CASActivity -ResultSetSize 9999}
$SuccessTests += {Get-CASActivity -ResultSetSize 10000}

$SuccessTests += {Get-CASAlert -ResultSetSize 1}
$SuccessTests += {Get-CASAlert -ResultSetSize 2}
$SuccessTests += {Get-CASAlert -ResultSetSize 1 | Get-CASAlert}
$SuccessTests += {Get-CASAlert -ResultSetSize 2 | Get-CASAlert}
$SuccessTests += {Get-CASAlert -ResultSetSize 9999}
$SuccessTests += {Get-CASAlert -ResultSetSize 10000}

$SuccessTests += {Get-CASFile -ResultSetSize 1}
$SuccessTests += {Get-CASFile -ResultSetSize 2}
$SuccessTests += {Get-CASFile -ResultSetSize 1 | Get-CASFile}
$SuccessTests += {Get-CASFile -ResultSetSize 2 | Get-CASFile}
$SuccessTests += {Get-CASFile -ResultSetSize 4999}
$SuccessTests += {Get-CASFile -ResultSetSize 5000}

#endregion ---------- Success Tests ----------


#region ---------- Failure Tests ----------

$FailureTests += {Get-CASAccount -ResultSetSize -1}
$FailureTests += {Get-CASAccount -ResultSetSize 0}
$FailureTests += {Get-CASAccount -ResultSetSize 5001}

$FailureTests += {Get-CASActivity -ResultSetSize -1}
$FailureTests += {Get-CASActivity -ResultSetSize 0}
$FailureTests += {Get-CASActivity -ResultSetSize 10001}

$FailureTests += {Get-CASAlert -ResultSetSize -1}
$FailureTests += {Get-CASAlert -ResultSetSize 0}
$FailureTests += {Get-CASAlert -ResultSetSize 10001}

$FailureTests += {Get-CASFile -ResultSetSize -1}
$FailureTests += {Get-CASFile -ResultSetSize 0}
$FailureTests += {Get-CASFile -ResultSetSize 5001}

#endregion ---------- Failure Tests ----------


$SuccessTestResults += $SuccessTests | ForEach {Test-ForErrors $_ -Verbose}
If ($SuccessTestResults.Count -ne 0)
{
    Write-Warning ("Testing found "+$SuccessTestResults.Count+" unexpected errors in success tests:")
    $SuccessTestResults | FT TestItem,Result
} 
Else 
{
    $OverallSuccess = $true
}

$FailureTestResults += $FailureTests | ForEach {Test-ForErrors $_ -Verbose}
If ($FailureTestResults.Count -ne $FailureTests.Count)
{
    Write-Warning ("Testing found "+$FailureTestResults.Count+" errors when "+$FailureTests.Count+" errors were expected:")
    $FailureTestResults | FT TestItem,Result
} 
Else 
{
    $OverallSuccess = $true
}

Return $OverallSuccess