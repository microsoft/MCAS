<#
.Synopsis
   Lists the administrators that have been granted access to the MCAS portal via an MCAS role. (Does not include admins with Azure AD admin roles, like Global Admin.) 
.DESCRIPTION
   Get-MCASAdminAccess list existing user accounts with MCAS admin rights and the permission type they have within MCAS.

.EXAMPLE
    PS C:\> Get-MCASAdminAccess

.EXAMPLE
    PS C:\> Get-MCASAdminAccess 'bob@contoso.com' READ_ONLY
    username          permission_type
    --------          ---------------
    alice@contoso.com FULL_ACCESS
    bob@contoso.com   READ_ONLY

.FUNCTIONALITY
   Get-MCASAdminAccess is intended to list the administrators assigned in an MCAS tenant.
#>
function Get-MCASAdminAccess {
    [CmdletBinding()]
    Param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path '/cas/api/v1/manage_admin_access/' -Method Get
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data 
    
    $response
}