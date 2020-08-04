

function Get-MCASOAuthApp {
    <#
    .Synopsis
       Get-MCASOAuthApp
    .DESCRIPTION
       Get-MCASOAuthApp retrives OAuth Apps that were granted permission 
    .EXAMPLE
    
        Get-MCASOAuthApp
    
    .EXAMPLE

    $AllOAuthApps = Get-MCASOAuthApp
    $FirstPartyNames = 'Microsoft', 'Microsoft Office Demos'
    $NotFirstParty = $AllOAuthApps | 
    Where publisher -NotIn $FirstPartyNames | 
    Select appName, _id, publisher, userCount, userInstallationCount, @{l='firstInstalled';e={(ConvertFrom-MCASTimestamp $_.firstInstalled)}}
    $NotFirstParty | Export-Csv -path C:\Temp\NotFirstPartyApps.csv

    The first command returns all OAuth apps and assigns to the AllOAuthApps variable
    The second command creates an array of First party app names
    The third command  will assigns a listing of all users for applications where the publisher is not first party to the NotFirstParty variable
    The fourth commaned exports the stored variable to a CSV

    .PARAMETER Credential
        Specifies the credential object containing tenant as username (e.g.
        'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
    #>
    
    
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )

Begin{}
Process{
                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/app_permissions/" -Method Get
                    $oauthapps = $response.data | Where-Object {$_.isinternal -eq $false}
                }
                catch {
                    throw "Error calling MCAS API. The exception was: $_"
                }
}
End{
    $oauthapps
}
}
    