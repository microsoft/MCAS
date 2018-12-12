function Set-MCASDiscoveredApp {
    [CmdletBinding()]
    Param
    (    
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Sanctioned','Unsanctioned',$null)]
        [string]$MarkAs
    )
    process {
        


    }
}
