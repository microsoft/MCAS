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
        [ValidateNotNullOrEmpty()]
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
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
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
        If ($Dismiss) {$Action = 'dismiss'}
        If ($MarkAs)  {$Action = $MarkAs.ToLower()} # Convert -MarkAs to lower case, as expected by the CAS API

        Try {
                # Set the alert's state by its id
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/alerts/$Identity/$Action/" -Token $Token -Method Post
            }
            Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            
            Write-Verbose "Checking response for success" 
            If ($Response.StatusCode -eq '200') {
                $Success = $true
                Write-Verbose "Successfully modified alert $Identity" 
            }
            Else {
                $Success = $false
                Write-Verbose "Something went wrong attempting to modify alert $Identity" 
                Write-Error "Something went wrong attempting to modify alert $Identity"
            }

            If (!$Quiet) {
                $Success
            }
    }
    End
    {
    }
}
