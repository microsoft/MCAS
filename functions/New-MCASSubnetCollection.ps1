<#
.Synopsis
   Defines new subnet collections in MCAS for enrichment of IP address information.
.DESCRIPTION
   New-MCASSubnetCollection creates subnet collections in the MCAS tenant.

.EXAMPLE
    PS C:\> New-MCASSubnetCollection -Name 'Contoso Egress IPs' -Category Corporate -Subnets '1.1.1.1/32','2.2.2.2/32'
    5a9e04c7f82b1bb8af51c7fb

.EXAMPLE
    PS C:\> New-MCASSubnetCollection -Name 'Contoso Internal IPs' -Category Corporate -Subnets '10.0.0.0/8' -Quiet

.FUNCTIONALITY
   New-MCASSubnetCollection is intended to return the unique id of the subnet collections that it creates in the MCAS tenant.
#>
function New-MCASSubnetCollection {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [ip_category]$Category,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}\/\d{1,2}$|^[a-zA-Z0-9:]{3,39}\/\d{1,3}$')]
        [string[]]$Subnets,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Tags,

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
    )
    process {
        $body = [ordered]@{'name'=$Name;'category'=($Category -as [int]);'subnets'=$Subnets}

        if ($Tags) {
            $body.Add('tags',$Tags)
        }
        
        if ($Organization) {
            $body.Add('organization',$Organization)
        }

        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/subnet/create_rule/" -Method Post -Body $body
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }

        if (!$Quiet) {
            $response
        }
    }
}