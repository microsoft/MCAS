<#
.Synopsis
   Sets the status of alerts in Cloud App Security.

.DESCRIPTION
   Sets the status of alerts in Cloud App Security and requires a credential be provided.

   There are two parameter sets:

   MarkAs: Used for marking an alert as 'Read' or 'Unread'.
   Dismiss: Used for marking an alert as 'Dismissed'.

   An alert identity is always required to be specified either explicity or implicitly from the pipeline.

.EXAMPLE
   Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -MarkAs Read

    This marks a single specified alert as 'Read'.

.EXAMPLE
   Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -Dismiss

    This will set the status of the specified alert as "Dismissed".

.EXAMPLE
   Get-MCASAlert -Unread -SortBy Date -SortDirection Descending -ResultSetSize 10 | Set-MCASAlert -MarkAs Read

    This will pull the last 10 alerts that were generated with a status of 'Unread' and will mark them all as 'Read'.

.FUNCTIONALITY
   Set-MCASAlert is intended to function as a mechanism for setting the status of alerts Cloud App Security.
#>
function Set-MCASAlert
{
    [CmdletBinding()]
    [Alias('Set-CASAlert')]
    Param
    (
        # Specifies an alert object by its unique identifier.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,

        # Specifies how to mark the alert. Possible Values: 'Read', 'Unread'.
        [Parameter(ParameterSetName='MarkAs',Mandatory=$true, Position=1)]
        [ValidateSet('Read','Unread')]
        [string]$MarkAs,

        # Specifies that the alert should be dismissed.
        [Parameter(ParameterSetName='Dismiss',Mandatory=$true)]
        [switch]$Dismiss,

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
        $Endpoint = 'alerts'

        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
        If ($Dismiss) {$Action = 'dismiss'}
        If ($MarkAs)  {$Action = $MarkAs.ToLower()} # Convert -MarkAs to lower case, as expected by the CAS API

        Try
            {
                # Set the alert's state by its id
                $SetResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix "$Identity/$Action/" -Method Post -Token $Token
            }
            Catch
                {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $SetResponse
    }
    End
    {
    }
}
