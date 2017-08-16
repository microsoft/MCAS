<#
.Synopsis
    Get-MCASStream retrieves a list of available discovery streams.
.DESCRIPTION
    Discovery streams are used to separate or aggregate discovery data. Stream ID's are needed when pulling discovered app data.
.EXAMPLE
    (Get-MCASStream | ?{$_.displayName -match 'Global'})._id

    57869aceb4b3d5154f095af7

    This example retrives the global stream ID.
#>
function Get-MCASStream
{
    [CmdletBinding()]
    [Alias('Get-CASStream')]
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
    Begin
    {
        $Endpoint = 'discovery'

        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
    }
    End
    {
            # Get the matching items and handle errors
            Try
            {
                $Response = Invoke-MCASRestMethod -TenantUri $TenantUri -ApiVersion $null -Endpoint $Endpoint -EndpointSuffix 'streams/' -Method Get -Token $Token
            }
                Catch
                {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
                $Response.streams
    }
}
