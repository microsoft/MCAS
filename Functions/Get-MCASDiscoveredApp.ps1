<#
.Synopsis
    Gets a list of discovered apps based on uploaded log files.
.DESCRIPTION
    This function retrives traffic and usage information about discovered apps.
.EXAMPLE
    Get-MCASDiscoveredApp -StreamId $streamid | select name -First 5

    name
    ----
    1ShoppingCart
    ABC News
    ACTIVE
    AIM
    AT&T

    Retrieves the first 5 app names sorted alphabetically.
.EXAMPLE
    Get-MCASDiscoveredApp -StreamId $streamid -Category SECURITY | select name,@{N='Total (MB)';E={"{0:N2}" -f ($_.trafficTotalBytes/1MB)}}

    name                   Total (MB)
    ----                   ----------
    Blue Coat              19.12
    Globalscape            0.00
    McAfee Control Console 1.28
    Symantec               0.20
    Websense               0.06

    In this example we pull back only discovered apps in the security category and display a table of names and Total traffic which we format to 2 decimal places and divide the totalTrafficBytes property by 1MB to show the traffic in MB.

#>
function Get-MCASDiscoveredApp
{
    [CmdletBinding()]
    [Alias('Get-CASDiscoveredApp')]
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

        # Specifies the property by which to sort the results. Set to 'Name' by default. Possible Values: 'UserName','LastSeen'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('IpCount','LastUsed','Name','Transactions','Upload','UserCount')]
        [ValidateNotNullOrEmpty()]
        [string]$SortBy='Name',

        # Specifies the direction in which to sort the results. Set to 'Ascending' by default. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [ValidateNotNullOrEmpty()]
        [string]$SortDirection='Ascending',

        # Specifies the maximum number of results (up to 5000) to retrieve when listing items matching the specified filter criteria. Set to 100 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,5000)]
        [ValidateNotNullOrEmpty()]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip. Set to 0 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0,

        ##### FILTER PARAMS #####

        # Limits results by category type. A preset list of categories are included.
        [Parameter(ParameterSetName='List', Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [app_category[]]$Category,

        # Limits the results by risk score range, for example '3-9'. Set to '1-10' by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidatePattern('^([1-9]0?)-([1-9]0?)$')]
        [ValidateNotNullOrEmpty()]
        [string]$ScoreRange='1-10',

        # Limits the results by stream ID, for example '577d49d72b1c51a0762c61b0'. The stream ID can be found in the URL bar of the console when looking at the Discovery dashboard.
        [Parameter(ParameterSetName='List', Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern('^[A-Fa-f0-9]{24}$')]
        [ValidateNotNullOrEmpty()]
        [string]$StreamId,

        # Limits the results by time frame in days. Set to 90 days by default. (Options: 7, 30, or 90)
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('7','30','90')]
        [ValidateNotNullOrEmpty()]
        [int]$TimeFrame=90
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
    }
    End
    {
        If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            $Body = @{
                'skip'=$Skip;
                'limit'=$ResultSetSize;
                'score'=$ScoreRange;
                'timeframe'=$TimeFrame;
                'streamId'=$StreamId
                } # Base request body

            If ($Category){
                $Body += @{'category'="SAASDB_CATEGORY_$Category"}
            }

            If ($SortBy -xor $SortDirection) {Write-Error 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.' -ErrorAction Stop}

            # Add sort direction to request body, if specified
            If ($SortDirection -eq 'Ascending')  {$Body.Add('sortDirection','asc')}
            If ($SortDirection -eq 'Descending') {$Body.Add('sortDirection','desc')}

            # Add sort field to request body, if specified
            Switch ($SortBy) {
                'Name'         {$Body.Add('sortField','name')}
                'UserCount'    {$Body.Add('sortField','usersCount')}
                'IpCount'      {$Body.Add('sortField','ipAddressesCount')}
                'LastUsed'     {$Body.Add('sortField','lastUsed')}
                'Upload'       {$Body.Add('sortField','trafficUploadedBytes')}
                'Transactions' {$Body.Add('sortField','trafficTotalEvents')}
                }

            Try
            {
                $Response = (Invoke-Restmethod -Uri "https://$TenantUri/cas/api/discovery/" -Body $Body -Headers @{Authorization = "Token $Token"} -UseBasicParsing -ErrorAction Stop -Method Get).data
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
}
