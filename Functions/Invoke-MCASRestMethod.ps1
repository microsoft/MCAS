function Invoke-MCASRestMethod
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$TenantUri,

        [Parameter(Mandatory=$true)]
        [ValidateSet('accounts','activities','alerts','discovery','files','governance','discovery_block_scripts','manage_admin_access')]
        [string]$Endpoint,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Get','Post','Put','Delete')]
        [string]$Method,

        [switch]$CASPrefix,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$EndpointSuffix,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        $Body,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Token,

        [Parameter(Mandatory=$false)]
        [ValidateSet($null,'/v1')]
        [string]$ApiVersion = '/v1',

        [Switch]$Raw,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$ContentType = 'application/json',

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        $FilterSet
    )

    If ($CASPrefix) {
        $Uri = "https://$TenantUri/cas/api$ApiVersion/$Endpoint/"
    }
    Else {
        $Uri = "https://$TenantUri/api$ApiVersion/$Endpoint/"
    }

    If ($EndpointSuffix) {
        $Uri += $EndpointSuffix
    }

    Try {
        If ($Body) {
            $JsonBody = $Body | ConvertTo-Json -Compress -Depth 2

            If ($FilterSet) {
                $JsonBody = $JsonBody.TrimEnd('}') + ',' + '"filters":{' + ((ConvertTo-MCASJsonFilterString $FilterSet).TrimStart('{')) + '}'
                }

            Write-Verbose "Invoke-MCASRestMethod: Request body: $JsonBody"
            $Response = Invoke-WebRequest -Uri $Uri -Body $JsonBody -Headers @{Authorization = "Token $Token"} -Method $Method -ContentType $ContentType -UseBasicParsing -ErrorAction Stop
        }
        Else {
            $Response = Invoke-WebRequest -Uri $Uri -Headers @{Authorization = "Token $Token"} -Method $Method -ContentType $ContentType -UseBasicParsing -ErrorAction Stop
        }
    }
    Catch {
        If ($_ -like 'The remote server returned an error: (404) Not Found.') {
            Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid." -ErrorAction Stop
        }
        ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.') {
            Write-Error '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified token is valid.' -ErrorAction Stop
        }
        ElseIf ($_ -match "The remote name could not be resolved: ") {
            Write-Error "The remote name could not be resolved: '$TenantUri'. Check to ensure the -TenantUri parameter is valid." -ErrorAction Stop
        }
        ElseIf ($_ -like "The remote server returned an error: (429) TOO MANY REQUESTS.") {
            Write-Error '429 - Too many requests. Do not exceed 30 requests/min. Please wait and try again.'
        }
        Else {
            Write-Error "Unknown exception when attempting to contact the Cloud App Security REST API: $_" -ErrorAction Stop
        }
    }

    Write-Verbose "Invoke-MCASRestMethod: Raw response from MCAS REST API: $Response"
    If ($Raw) {
        $Response
    }
    Else {
        # Windows/Powershell case insensitivity causes collision of properties with same name but different case, so this patches the problem
        If ($Endpoint -eq 'accounts') {
            $Response = $Response -creplace '"Id":', '"Id_int":'
            Write-Verbose "Invoke-MCASRestMethod: A property name collision was detected in the response from MCAS REST API $Endpoint endpoint for the following property names; 'id' and 'Id'. The 'Id' property was renamed to 'Id_int'."
        }

        If ($Endpoint -eq 'files') {
            $Response = $Response -creplace '"Created":', '"Created_2":'
            Write-Verbose "Invoke-MCASRestMethod: A property name collision was detected in the response from MCAS REST API $Endpoint endpoint for the following property names; 'created' and 'Created'. The 'Created' property was renamed to 'Created_2'."

            $Response = $Response -creplace '"ftags":', '"ftags_2":'
            Write-Verbose "Invoke-MCASRestMethod: A property name collision was detected in the response from MCAS REST API $Endpoint endpoint for the following property names; 'ftags' and 'fTags'. The 'ftags' property was renamed to 'ftags_2'."
        }

        If ($Endpoint -eq 'discovery') {
            $Response = $Response.Content
        }
        
        # Convert from JSON to Powershell objects
        Write-Verbose "Invoke-MCASRestMethod: Modified response before JSON conversion: $Response"
        $Response = $Response | ConvertFrom-Json
        
        # For list responses with zero results, set an empty collection as response rather than returning the response metadata
        If (($Response.total -eq 0) -or (($Response.data).count -eq 0)) {
            $Response = @()
        }
        # For list responses, get the data property only
        ElseIf ($null -ne $Response.data) {
            $Response = $Response.data
        }

        # Add 'Identity' alias property, when appropriate
        If (($null -ne $Response) -and ($Response | Get-Member).name -contains '_id') {
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru
        }

        $Response
    }
}
