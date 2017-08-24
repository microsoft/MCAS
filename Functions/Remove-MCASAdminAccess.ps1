function Remove-MCASAdminAccess
{
    [CmdletBinding()]
    [Alias('Remove-CASAdminAccess')]
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
        [string]$Username
    )
    Begin
    {
        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
        If ((Get-MCASAdminAccess).username -notcontains $Username) {
            Write-Warning "$Username is not listed as an administrator of Cloud App Security. No changes were made."
            }
        Else {
            Try {
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/cas/api/v1/manage_admin_access/$Username/" -Token $Token -Method Delete
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

            If ($Response.StatusCode -eq '200') {
                Write-Verbose "$Username was removed from MCAS admin list"
            }
            Else {
                Write-Error "$Username could not be removed from MCAS admin list"
            }
        }
    }
    End
    {
    }
}
