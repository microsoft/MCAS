<#
.Synopsis
   Adds administrators to the MCAS portal. 
.DESCRIPTION
   Add-MCASAdminAccess grants existing user accounts the MCAS full admin or read-only admin role within MCAS.

.EXAMPLE
    C:\>Add-MCASAdminAccess -Username 'alice@contoso.com' -PermissionType FULL_ACCESS

.EXAMPLE
    C:\>Add-MCASAdminAccess 'bob@contoso.com' READ_ONLY
    WARNING: READ_ONLY acces includes the ability to manage MCAS alerts.

.FUNCTIONALITY
   Add-MCASAdminAccess is intended to add administrators to an MCAS tenant.
#>
function Add-MCASAdminAccess {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [permission_type]$PermissionType
    )
    begin {
        # Keep track if any read-only access is added
        $readOnlyAdded = $false

        Write-Verbose "Checking current admin list."
        $preExistingAdmins = Get-MCASAdminAccess -Credential $Credential
    }
    process {
        if ($preExistingAdmins.username -contains $Username) {
            Write-Warning "$Username is already listed as an administrator of Cloud App Security."
            }
        else {
            $body = [ordered]@{'username'=$Username;'permissionType'=($PermissionType -as [string])}

            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path '/cas/api/v1/manage_admin_access/' -Method Post -Body $body
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }

            if ($PermissionType -eq 'READ_ONLY') {
                $readOnlyAdded = $true
            }
        }
    }
    end {
        if ($readOnlyAdded) {
            Write-Warning "READ_ONLY acces includes the ability to manage MCAS alerts."
        }
    }
}