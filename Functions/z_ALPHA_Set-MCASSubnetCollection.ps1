function Set-MCASSubnetCollection {
    [CmdletBinding()]
    Param
    (    
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("[a-z0-9]{24}")]
        [alias("_id")]
        [string]$Identity,
    
        [Parameter(Mandatory=$false,ValueFromPipeline=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [ip_category]$Category,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}\/\d{1,2}$|^[a-zA-Z0-9:]{3,39}\/\d{1,3}$')]
        [string[]]$Subnets,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Tags,

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
    )

    process {
        # Get the object by its id
        $item = Get-MCASSubnetCollection -Credential $Credential | Where-Object {$_._id -eq $Identity}



        
        
        Write-Host -ForegroundColor Cyan "Before:"
        $item
        
        

        

        # Modify the object properties based on params provided
        if ($Name) {
            $item.name = $Name
        }
        
        if ($Category) {
            $item.category = $Category
        }

        if ($Subnets) {
            $item.subnets = $Subnets
        }

        if ($Tags) {
            $item.tags = $Tags
        }

        if ($Organization) {
            $item.organization = $Organization
        }

        # Fixup any properties that need fixing
        if ($item.tags -eq (@{})) {
            $item.tags = $null
        }
        #$item.tags = $null





        Write-Host -ForegroundColor Cyan "After:"
        $item

        
        
        
        
        # Convert the object into a hashtable, then a JSON document
        $body = @{}
        
        $item.psobject.properties | ForEach-Object {$body.Add($_.Name,$_.Value) }
        
        $body = $body | ConvertTo-Json -Compress -Depth 3


        

        Write-Host -ForegroundColor Cyan "Body:"
        $body







        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/subnet/$Identity/update_rule/" -Method Post -Body $body
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }
        
        <#
        Write-Verbose "Checking response for success" 
        if ($response.StatusCode -eq '200') {
            Write-Verbose "Successfully modified subnet $NameOrIdTargeted" 
        }
        else {
            Write-Verbose "Something went wrong attempting to modify subnet $NameOrIdTargeted" 
            Write-Error "Something went wrong attempting to modify subnet $NameOrIdTargeted"
        }  
        #>

        #$response = $response.content | ConvertFrom-Json

        if (!$Quiet) {
            $response
        }
    }
}
