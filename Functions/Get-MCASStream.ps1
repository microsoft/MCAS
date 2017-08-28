<#
.Synopsis
    Get-MCASStream retrieves a list of available discovery streams.
.DESCRIPTION
    Discovery streams are used to separate or aggregate discovery data. Stream ID's are needed when pulling discovered app data.
.EXAMPLE
    (Get-MCASStream | ?{$_.displayName -eq 'Global View'})._id

    57869acdb4b3d5154f095af7

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

    Try {$TenantUri = Select-MCASTenantUri}
        Catch {Throw ($MyInvocation.InvocationName) + ': ' + (Resolve-MCASException $_)}

    Try {$Token = Select-MCASToken}
        Catch {Throw ($MyInvocation.InvocationName) + ': ' + (Resolve-MCASException $_)}

    # Get the matching items and handle errors
    Try
    {
        $Response = Invoke-RestMethod -Uri "https://$TenantUri/api/discovery/streams/" -Method Get -Headers @{Authorization = "Token $Token"} -ContentType 'application/json' -UseBasicParsing -ErrorAction Stop
    }
        Catch
        {
            Throw $_.Exception
        }

    $Response = $Response.Streams
    
    # Add 'Identity' alias property
    If (($null -ne $Response) -and ($Response | Get-Member).name -contains '_id') {
        $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru
        }
        
    $Response
}
