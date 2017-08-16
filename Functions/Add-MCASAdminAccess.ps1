function Add-MCASAdminAccess
{
    [CmdletBinding()]
    [Alias('Add-CASAdminAccess')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [permission_type]$PermissionType
    )
    Begin
    {
        $Endpoint = 'manage_admin_access'

        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}

        $ReadOnlyAdded = $false
    }
    Process
    {
        If ((Get-MCASAdminAccess).username -contains $Username) {
            Write-Warning "Add-MCASAdminAccess: $Username is already listed as an administrator of Cloud App Security. No changes were made."
            }
        Else {
            $Body = [ordered]@{'username'=$Username;'permissionType'=($PermissionType -as [string])}

            Try {
                $Response = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -CASPrefix -Method Post -Token $Token -Body $Body
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            
            If ($PermissionType -eq 'READ_ONLY') {
                    $ReadOnlyAdded = $true
                }
            
            $Response
            }
    }
    End
    {
        If ($ReadOnlyAdded) {
            Write-Warning "Add-MCASAdminAccess: READ_ONLY acces includes the ability to manage alerts."
        }
    }
}
