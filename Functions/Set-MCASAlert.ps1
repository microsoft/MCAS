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

.EXAMPLE
    PS C:\> $IdList = Get-MCASAlert -resultsetsize 10 | Select -expand Identity
            Set-MCASAlert -BulkDismiss $IdList 

    This will perform a bulk dismiss on an array of 10 ID's. 

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

        # Bulk dismiss an array of ID's. This parameter expects a single list of Id's in array format. Note, this API call only accepts 100 ID's at a time, so if you pass in more than 100 this cmdlet will break them into chunks for each call automatically. 
        [Parameter(ParameterSetName='BulkDismiss', Mandatory=$false, ValueFromPipeline=$true)]
        [array]$BulkDismiss,

        # Bulk reopen an array of ID's. This parameter expects a single list of Id's in array format. Note, this API call only accepts 100 ID's at a time, so if you pass in more than 100 this cmdlet will break them into chunks for each call automatically. 
        [Parameter(ParameterSetName='BulkReopen', Mandatory=$false, ValueFromPipeline=$true)]
        [array]$BulkReopen,

        # Comment - Relevant for the bulk parameters, but not ready to add this yet to release.
        #[Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        #[string]$Comment = "Bulk Dismiss",       

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
    )
    begin{
    }
    process
    {

        if (!($MarkAs -or $Dismiss -or $BulkDismiss -or $BulkReopen)) {
            throw "You must specify at least one of the following: -MarkAs, -Dismiss, -BulkDismiss, or -BulkReopen."
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
  

        if ($PSCmdlet.ParameterSetName -eq 'BulkDismiss') {
            try {
                # Set the alert's state by its id

                $body = @{ 
                        #comment = $comment
                        filters = @{
                            id = @{
                                eq = @()
                        }
                    }
                }

                $idcount = $BulkDismiss.count
                $i = 0
                do {
                    $BulkDismiss | select -first 100 -skip $i | foreach {$body.filters.id.eq += $_}
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/dismiss_bulk/" -Body $body -Method Post
                    $i += 100
                    $body.filters.id.eq = @()
                }
                until ($i -ge $idcount)
            }
            catch {
                throw $_
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'BulkReopen') {
            try {
                # Set the alert's state by its id

                $body = @{ 
                        #comment = $comment
                        filters = @{
                            id = @{
                                eq = @()
                        }
                    }
                }

                $idcount = ($BulkReopen | measure-object).count
                $i = 0
                do {
                    $BulkReopen | select -first 100 -skip $i | foreach {$body.filters.id.eq += $_}
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/reopen/" -Body $body -Method Post
                    $i += 100
                    $body.filters.id.eq = @()
                }
                until ($i -ge $idcount)
            }
            catch {
                throw $_
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

        if (!$Quiet) {
            $Success
        }
    }
}