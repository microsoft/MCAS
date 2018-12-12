<#
.Synopsis
   Gets all General, Security, and Compliance info for a provided app ID.

.DESCRIPTION
    By passing in an App Id, the user can retrive information about those apps straight from the SaaS DB. This information is returned in an object format that can be formatted for the user's needs.

.EXAMPLE
    PS C:\> Get-MCASAppInfo -AppId 11114 | select name, category

    name       category
    ----       --------
    Salesforce SAASDB_CATEGORY_CRM

.EXAMPLE
    PS C:\> Get-MCASAppInfo -AppId 18394 | select name, @{N='Compliance';E={"{0:N0}" -f $_.revised_score.compliance}}, @{N='Security';E={"{0:N0}" -f $_.revised_score.security}}, @{N='Provider';E={"{0:N0}" -f $_.revised_score.provider}}, @{N='Total';E={"{0:N0}" -f $_.revised_score.total}} | ft

    name        Compliance Security Provider Total
    ----        ---------- -------- -------- -----
    Blue Coat   4          8        6        6

    This example creates a table with just the app name and high level scores.

.FUNCTIONALITY
    Get-MCASAppInfo is designed to query the saasdb one service at a time, not in bulk fashion.
#>
function Get-MCASAppInfo {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{5}$')]
        [Alias("Service","Services")]
        [int[]]$AppId,
                
        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0
    )
    begin {
        $appIdList = @()
    }
    process {
        $appIdList += $AppId
    }
    end {
        $body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body
        
        $filterSet = @() # Filter set array

        # Simple filters
        if ($appIdList.Count -gt 0) {$filterSet += @{'appId'= @{'eq'=$AppIdList}}}

        # Get the matching alerts and handle errors
        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/saasdb/" -Method Post -Body $body -FilterSet $filterSet
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }

        $response = $response.data

        try {
            Write-Verbose "Adding alias property to results, if appropriate"
            $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value 'appId' -PassThru
        }
        catch {}

        $response
    }
}