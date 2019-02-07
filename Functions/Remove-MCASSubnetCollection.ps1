<#
.Synopsis
   Removes a subnet collection in MCAS, as specified by its unique id
.DESCRIPTION
   Remove-MCASSubnetCollection deletes subnet collections in the MCAS tenant.

.EXAMPLE
    PS C:\> Remove-MCASSubnetCollection -Identity '5a9e04c7f82b1bb8af51c7fb'

.EXAMPLE
    PS C:\> Get-MCASSubnetCollection | Remove-MCASSubnetCollection

.FUNCTIONALITY
   Remove-MCASSubnetCollection is intended to remove the specified subnet collection from the MCAS tenant.
#>
function Remove-MCASSubnetCollection {
    [CmdletBinding()]
    Param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(ParameterSetName='ById',Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("[a-z0-9]{24}")]
        [alias("_id")]
        [string]$Identity,

        [Parameter(ParameterSetName='ByName',Mandatory=$true,ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'ByName') {
            Write-Verbose "Parameter set 'ByName' detected"

            Get-MCASSubnetCollection -Credential $Credential | ForEach-Object {
                if ($_.Name -eq $Name) {
                    $SubnetId = $_.Identity
                    $NameOrIdTargeted = $Name
                }
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'ById') {
            Write-Verbose "Parameter set 'ById' detected"
            $SubnetId = $Identity
            $NameOrIdTargeted = $SubnetId
        }
        else {
            Write-Verbose "Parameter set not detected"
            Write-Error "Could not determine identity of subnet to be deleted"
        }

        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/subnet/$SubnetId/" -Method Delete 
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }
        
        if (!$Quiet) {
            $Success
        }      
    }
}