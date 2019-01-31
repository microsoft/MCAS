<#
.Synopsis
   Gets all General, Security, and Compliance info for a provided app ID.

.DESCRIPTION
    By passing in an App Id, the user can retrive information about those apps straight from the SaaS DB. This information is returned in an object format that can be formatted for the user's needs.

.EXAMPLE
    PS C:\> Get-MCASAppInfo -AppId @(11114,11161) | select name, category

    name       category
    ----       --------
    Salesforce SAASDB_CATEGORY_CRM

.EXAMPLE
    PS C:\> Get-MCASAppInfo -AppId @(18394) | select name, @{N='Compliance';E={"{0:N0}" -f $_.revised_score.compliance}}, @{N='Security';E={"{0:N0}" -f $_.revised_score.security}}, @{N='Provider';E={"{0:N0}" -f $_.revised_score.provider}}, @{N='Total';E={"{0:N0}" -f $_.revised_score.total}} | ft

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
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName = 'List', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{5}$')]
        [Alias("Service", "Services")]
        [array]$AppId
    )
    begin {
        $collection = @()
    }
    process {
    }
    end {
        # Simple filters
        if ($AppId.Count -gt 0) {

            $AppId | ForEach-Object {
                $curAppId = $_
                Write-Warning "$curAppId"
                # Get the matching alerts and handle errors
                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/saasdb/$curAppId/" -Method Get
                }
                catch {
                    throw "Error calling MCAS API. The exception was: $_"
                }

                $collection += $response
            }
        }
        $collection
    }
}