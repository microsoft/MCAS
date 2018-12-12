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
    PS C:\> Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -MarkAs Read

    This marks a single specified alert as 'Read'.

.EXAMPLE
    PS C:\> Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -Dismiss

    This will set the status of the specified alert as "Dismissed".

.FUNCTIONALITY
   Set-MCASAlert is intended to function as a mechanism for setting the status of alerts Cloud App Security.
#>
function Set-MCASAlert {
    [CmdletBinding()]
    param
    (
        # Fetches an alert object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity,

        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies how to mark the alert. Possible Values: 'Read', 'Unread'.
        [Parameter(Mandatory=$false)]
        [ValidateSet('Read','Unread')]
        [string]$MarkAs,

        # Specifies that the alert should be dismissed.
        [Parameter(Mandatory=$false)]
        [switch]$Dismiss,

        # Specifies that the alert should be resolved.
        [Parameter(Mandatory=$false)]
        [switch]$Resolve,

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
    )
    process
    {
        if (!($MarkAs -or $Dismiss -or $Resolve)) {
            throw "You must specify at least one action: MarkAs, Dismiss, or Resolve."
        }

        if ($Dismiss -and $Resolve) {
            throw "You may not mark an alert as both dismissed and resolved. Please choose only one action."
        }

        if ($Dismiss) {
            $Action = 'dismiss'
            try {
                # Set the alert's state by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/$Identity/$Action/" -Method Post
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }
        }
        if ($MarkAs)  {
            $Action = $MarkAs.ToLower() # Convert -MarkAs to lower case, as expected by the CAS API
            try {
                # Set the alert's state by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/$Identity/$Action/" -Method Post
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }
        }

        if ($Resolve)  {
            $Action = 'resolve'
            try {
                # Set the alert's state by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/$Identity/$Action/" -Method Post
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }
        }


        if (!$Quiet) {
            $Success
        }
    }
}