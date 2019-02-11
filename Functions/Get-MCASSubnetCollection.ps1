<#
.Synopsis
   Lists the subnet collections that are defined in MCAS for enrichment of IP address information.
.DESCRIPTION
   Get-MCASSubnetCollection gets subnet collections defined in the MCAS tenant.

.EXAMPLE
    PS C:\> Get-MCASSubnetCollection

    category     : 1
    subnets      : {@{originalString=10.0.0.0/8; mask=104; address=0000:0000:0000:0000:0000:ffff:0a00:0000}}
    name         : Contoso Internal IPs
    tags         : {}
    location     :
    _tid         : 26034820
    organization :
    _id          : 5a9e053df82b1bb8af51c802
    Identity     : 5a9e053df82b1bb8af51c802

    category     : 1
    subnets      : {@{originalString=1.1.1.1/32; mask=128; address=0000:0000:0000:0000:0000:ffff:0101:0101},
                @{originalString=2.2.2.2/32; mask=128; address=0000:0000:0000:0000:0000:ffff:0202:0202}}
    name         : Contoso Egress IPs
    tags         : {}
    location     :
    _tid         : 26034820
    organization :
    _id          : 5a9e04c7f82b1bb8af51c7fb
    Identity     : 5a9e04c7f82b1bb8af51c7fb

.FUNCTIONALITY
   Get-MCASSubnetCollection is intended to return the subnet collections that are defined in MCAS.
#>
function Get-MCASSubnetCollection {
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0
        
    )    
    $body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/subnet/" -Method Post -Body $body
    }
    catch {
        throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
    }

    $response = $response.data 
    
    try {
        Write-Verbose "Adding alias property to results, if appropriate"
        $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
    }
    catch {}
    
    $response
}