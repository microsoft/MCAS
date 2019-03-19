<#
.Synopsis
    New-MCASSiemAgentToken
.DESCRIPTION
    
.EXAMPLE

#>
function New-MCASSiemAgentToken {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Fetches a SIEM object by its unique identifier.
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity
    )
    
    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/agents/siem/$Identity/generate/" -Method Post
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.token
        
    $response
}