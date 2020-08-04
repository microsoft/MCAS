function Get-MCASOAuthAppUser {
    <#
    .Synopsis
        Get-MCASOAuthApps
    .DESCRIPTION
        Get-MCASOAuthApps retrives OAuth Apps that were granted permission 
    .EXAMPLE
    
        Get-MCASOAuthAppUser
    
    .PARAMETER Credential
        Specifies the credential object containing tenant as username (e.g.
        'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
    
    .PARAMETER OAuthAppID
        Is the '_ID' field returned from Get-MCASOauthApp.
    #>
    
    
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [string[]]$OAuthAppID
    )
    Begin{}
    Process{
        foreach ($App in $OAuthAppID) {
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/app_permissions/$OauthAppID/users/" -Method Get
                $AppName = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/app_permissions/$OauthAppID/" -Method Get
                foreach ($user in $response.data){
                    $obj = [PSCustomObject]@{
                        UserID          = $user.id | ConvertFrom-Json | Select-Object -ExpandProperty id
                        UserDisplayName = $user.entityData.'0'.displayname
                        IsAdmin         = $user.isAdmin
                        ApplicationName = $AppName.appName
                    }
                    $obj
                }
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }
        }
    }
    End{}
}