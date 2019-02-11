function Get-MCASDiscoveryDataSource {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    
    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/discovery/data_sources/?skip=0&limit=100&sortField=created&sortDirection=desc" -Method Get        
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data

    try {
        Write-Verbose "Adding alias property to results, if appropriate"
        $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
    }
    catch {}

    $response
}