function Invoke-MCASCallLimiting
{
    [CmdletBinding()]

    [int]$WaitSeconds = 3

    [datetime]$Now = Get-Date
    
    $Global:MCASApiCalls = $Global:MCASApiCalls | Where-Object {$_ -ge $Now.AddSeconds(-60)}

    [int]$CallsInLastMin = $Global:MCASApiCalls.count

    If ($CallsInLastMin -gt 20) {
        Write-Warning "There have been $CallsInLastMin calls in the last min. We are close to the API throttling limit, so the next MCAS API call will be postponed for $WaitSeconds second(s)"
        Start-Sleep -Seconds $WaitSeconds
    }
    Else {
        Write-Verbose "There have been $CallsInLastMin calls in the last min. We are not close to the API throttling limit, so the next MCAS API call will not be postponed"
    }

    $Global:MCASApiCalls += $Now
}