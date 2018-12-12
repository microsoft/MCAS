<#
.Synopsis
   Removes administrators from the MCAS portal. 
.DESCRIPTION
   Removce-MCASAdminAccess removes explicit MCAS admin roles from users assigned them within MCAS.

.EXAMPLE
    PS C:\> Remove-MCASAdminAccess -Username 'alice@contoso.com'

.EXAMPLE
    PS C:\> Remove-MCASAdminAccess 'bob@contoso.com' 

.FUNCTIONALITY
   Remove-MCASAdminAccess is intended to remove administrators from an MCAS tenant.
#>
function Remove-MCASAdminAccess {
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Username
    )

    if ((Get-MCASAdminAccess -Credential $Credential).username -notcontains $Username) {
        Write-Warning "$Username is not listed as an administrator of Cloud App Security."
        }
    else {
        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/manage_admin_access/$Username/" -Method Delete
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }
    }
}