function Get-MCASDiscoveredAppUser {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$AppID,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria. Set to 100 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100)]
        [ValidateNotNullOrEmpty()]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip. Set to 0 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0,

        # Limits the results by stream ID, for example '577d49d72b1c51a0762c61b0'. The stream ID can be found in the URL bar of the console when looking at the Discovery dashboard.
        [Parameter(ParameterSetName='List', Mandatory=$false, Position=0)]
        [ValidatePattern('^[A-Fa-f0-9]{24}$')]
        [ValidateNotNullOrEmpty()]
        [string]$StreamId,

        # Limits the results by time frame in days. Set to 90 days by default. (Options: 7, 30, or 90)
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('7','30','90')]
        [ValidateNotNullOrEmpty()]
        [int]$TimeFrame=90
    )

    if ($StreamId) {
        $stream = $StreamId
    }
    else {
        $stream = (Get-MCASStream | Where-Object {$_.displayName -eq 'Global View'}).Identity
    }

    $body = @{
        appId = $AppID
        limit= $ResultSetSize
        performAsyncTotal= $false
        skip= 0
        sortDirection= "desc"
        sortField= "lastSeen"
        streamId= $stream
        timeframe= $TimeFrame
    } # Base request body

    try {
        #$response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/discovery/" -Method Post -Body $body #-FilterSet $filterSet
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/discovery/app_users/" -Method Post -Body $body
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data

    $response
}