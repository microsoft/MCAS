function Get-MCASOAuthAppUser {
    <#
    .Synopsis
        Get-MCASOAuthApps
    .DESCRIPTION
        Get-MCASOAuthApps retrives OAuth Apps that were granted permission 

    .EXAMPLE
    
    Get-MCASOAuthApp | ForEach-Object { Get-MCASOAuthAppUser -OAuthAppID $_._id }

    This will return a listing of all users for the specified applications on the pipeline
    
    .EXAMPLE

    Get-MCASOAuthApp | ForEach-Object { Get-MCASOAuthAppUser -OAuthAppID $_._id } | Export-Csv -path C:\Temp\NotFirstPartyAppUsers.csv

    Exports a listing of all OAuthAppUsers to a CSV

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
        [string[]]$OAuthAppID,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria. Set to 100 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,1000)]
        [ValidateNotNullOrEmpty()]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip. Set to 0 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0
    )
    Begin{}
    Process{
        foreach ($App in $OAuthAppID) {
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/app_permissions/$OauthAppID/users/?skip=$Skip&limit=$ResultSetSize" -Method Get
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