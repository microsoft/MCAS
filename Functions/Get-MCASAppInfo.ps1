<#
.Synopsis
   Gets all General, Security, and Compliance info for a provided app ID.

.DESCRIPTION
    By passing in an App Id, the user can retrive information about those apps straight from the SaaS DB. This information is returned in an object format that can be formatted for the user's needs.

.EXAMPLE
    Get-MCASAppInfo -AppId 11114 | select name, category

    name       category
    ----       --------
    Salesforce SAASDB_CATEGORY_CRM

.EXAMPLE
    Get-MCASAppInfo -AppId 18394 | select name, @{N='Compliance';E={"{0:N0}" -f $_.revised_score.compliance}}, @{N='Security';E={"{0:N0}" -f $_.revised_score.security}}, @{N='Provider';E={"{0:N0}" -f $_.revised_score.provider}}, @{N='Total';E={"{0:N0}" -f $_.revised_score.total}} | ft

    name        Compliance Security Provider Total
    ----        ---------- -------- -------- -----
    Blue Coat   4          8        6        6

    This example creates a table with just the app name and high level scores.

.FUNCTIONALITY
       Get-MCASAppInfo is designed to query the saasdb one service at a time, not in bulk fashion.
#>
function Get-MCASAppInfo
{
    [CmdletBinding()]
    [Alias('Get-CASAppInfo')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('\b\d{5}\b')]
        [Alias("Service","Services")]
        [int[]]$AppId
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
            If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            $Body = @{'skip'=0;'limit'=100} # Base request body

            #region ----------------------------FILTERING----------------------------
            $FilterSet = @() # Filter set array

            # Simple filters
            If ($AppId) {$FilterSet += @{'appId'= @{'eq'=$AppId}}}

            # Add filter set to request body as the 'filter' property
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-MCASJsonFilterString $FilterSet))}

            #endregion -------------------------FILTERING----------------------------

            # Get the matching alerts and handle errors
            Try
            {
                $Response = ((Invoke-WebRequest -Uri "https://$TenantUri/api/v1/saasdb/" -Body $Body -Headers @{Authorization = "Token $Token"} -UseBasicParsing -Method Get -ErrorAction Stop) | ConvertFrom-Json).data
            }
            Catch
            {
                If ($_ -like 'The remote server returned an error: (404) Not Found.')
                {
                    Write-Error "404 - Not Found: Check to ensure the -TenantUri parameter is valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Write-Error '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified token is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Write-Error "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                Else
                {
                    Write-Error "Unknown exception when attempting to contact the Cloud App Security REST API: $_"
                }
            }
            If ($Response) {Write-Output $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
    End
    {
    }
}
