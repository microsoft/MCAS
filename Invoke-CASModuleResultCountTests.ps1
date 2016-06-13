
If (Get-Module Cloud-App-Security) {Remove-Module Cloud-App-Security}
$ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Import-Module "$ScriptPath\Cloud-App-Security.psm1"

#$CASCredential = Import-Clixml C:\Users\jpoeppel\mod102677.credential


# Initialize
$ErrorAction = 'Continue'
$CountTests = @()


$OverallSuccess = $true


#region ---------- Count Tests ----------

$CountTests += New-Object PSObject -Property @{'Test'={Get-CASAccount -ResultSetSize 1};'ExpectedCount'=1;'ResultCount'=$null}
$CountTests += New-Object PSObject -Property @{'Test'={Get-CASAccount -ResultSetSize 2};'ExpectedCount'=2;'ResultCount'=$null}

$CountTests += New-Object PSObject -Property @{'Test'={Get-CASActivity -ResultSetSize 1};'ExpectedCount'=1;'ResultCount'=$null}
$CountTests += New-Object PSObject -Property @{'Test'={Get-CASActivity -ResultSetSize 2};'ExpectedCount'=2;'ResultCount'=$null}

$CountTests += New-Object PSObject -Property @{'Test'={Get-CASAlert -ResultSetSize 1};'ExpectedCount'=1;'ResultCount'=$null}
$CountTests += New-Object PSObject -Property @{'Test'={Get-CASAlert -ResultSetSize 2};'ExpectedCount'=2;'ResultCount'=$null}

$CountTests += New-Object PSObject -Property @{'Test'={Get-CASFile -ResultSetSize 1};'ExpectedCount'=1;'ResultCount'=$null}
$CountTests += New-Object PSObject -Property @{'Test'={Get-CASFile -ResultSetSize 2};'ExpectedCount'=2;'ResultCount'=$null}

#endregion ---------- Count Tests ----------


ForEach ($t in $CountTests)
{
    $t.ResultCount = ((&($t.Test) | Measure-Object).Count)

    If ($t.ResultCount -ne $t.ExpectedCount)
    {
        $OverallSuccess = $false
        Write-Warning $t
    }
}

Write-Output $OverallSuccess