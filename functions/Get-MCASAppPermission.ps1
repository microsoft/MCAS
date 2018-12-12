function Get-MCASAppPermission {
    [CmdletBinding()]
    Param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0
    )
    $body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Request body

    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path '/cas/api/v1/app_permissions/' -Method Post -Body $body
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data

    $response
}