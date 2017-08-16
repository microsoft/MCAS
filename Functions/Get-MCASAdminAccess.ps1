function Get-MCASAdminAccess
{
    [CmdletBinding()]
    [Alias('Get-CASAdminAccess')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential
    )
    $Endpoint = 'manage_admin_access'

    Try {$TenantUri = Select-MCASTenantUri}
        Catch {Throw $_}

    Try {$Token = Select-MCASToken}
        Catch {Throw $_}

    Try
    {
        $Response = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -CASPrefix -Method Get -Token $Token
    }
        Catch
        {
            Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
        }

    $Response
}
