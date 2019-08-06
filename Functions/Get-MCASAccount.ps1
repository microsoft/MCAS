<#
.Synopsis
   Gets user account information from your Cloud App Security tenant.
.DESCRIPTION
   Gets user account information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASAccount gets 100 account records and associated properties. You can specify a particular account GUID to fetch a single account's information or you can pull a list of accounts based on the provided filters.

   Get-MCASAccount returns a single custom PS Object or multiple PS Objects with all of the account properties. Methods available are only those available to custom objects by default.
.EXAMPLE
    PS C:\> Get-MCASAccount -ResultSetSize 1

    username         : alice@contoso.com
    consolidatedTags : {}
    userDomain       : contoso.com
    serviceData      : @{20595=}
    lastSeen         : 2016-05-13T20:23:47.210000Z
    _tid             : 17000616
    services         : {20595}
    _id              : 572caf4588011e452ec18ef0
    firstSeen        : 2016-05-06T14:50:44.762000Z
    external         : False
    Identity         : 572caf4588011e452ec18ef0

    This pulls back a single user record and is part of the 'List' parameter set.

.EXAMPLE
    PS C:\> (Get-MCASAccount -UserDomain contoso.com).count

    2

    This pulls back all accounts from the specified domain and returns a count of the returned objects.

.EXAMPLE
    PS C:\> Get-MCASAccount -Affiliation External | select @{N='Unique Domains'; E={$_.userDomain}} -Unique

    Unique Domains
    --------------
    gmail.com
    outlook.com
    yahoo.com

    This pulls back all accounts flagged as external to the domain and displays only unique records in a new property called 'Unique Domains'.

.EXAMPLE
    PS C:\> (Get-MCASAccount -ServiceNames 'Microsoft Cloud App Security').serviceData.20595

    email                              lastLogin                   lastSeen
    -----                              ---------                   --------
    admin@mod.onmicrosoft.com          2016-06-13T21:17:40.821000Z 2016-06-13T21:17:40.821000Z

    This queries for any Cloud App Security accounts and displays the serviceData table containing the email, last login, and last seen properties. 20595 is the Service ID for Cloud App Security.

.FUNCTIONALITY
    Get-MCASAccount is intended to function as a query mechanism for obtaining account information from Cloud App Security.
#>
function Get-MCASAccount {
    [CmdletBinding()]
    param
    (
        # Fetches an account object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,

        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the property by which to sort the results. Possible Values: 'UserName','LastSeen'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Username','LastSeen')]
        [string]$SortBy,

        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0,


        ##### FILTER PARAMS #####

        # Limits the results to external users
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$External,

        # Limits the results to internal users
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Internal,

        # Limits the results to items related to the specified user names, such as 'alice@contoso.com','bob@contoso.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserName,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("Service","Services")]
        [int[]]$AppId,

        # Limits the results to items related to the specified service names, such as 'Office_365' and 'Google_Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("ServiceName","ServiceNames")]
        [mcas_app[]]$AppName,

        # Limits the results to items not related to the specified service ids, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("ServiceNot","ServicesNot")]
        [int[]]$AppIdNot,

        # Limits the results to items not related to the specified service names, such as 'Office_365' and 'Google_Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("ServiceNameNot","ServiceNamesNot")]
        [mcas_app[]]$AppNameNot,

        # Limits the results to items found in the specified user domains, such as 'contoso.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserDomain
    )
    begin {}
    process
    {
        # Fetch no longer works on the /accounts/ endpoint, so the code below was commented

        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($PSCmdlet.ParameterSetName -eq 'Fetch')
        {
            <#
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/accounts/$Identity/" -Method Get -Raw
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }

            $response = $response.content

            # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
            try {
                $response = $response | ConvertFrom-Json
            }
            catch {
                Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                $response = $response.Replace('"Id":','"Id_int":')
                try {
                    $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                }
                catch {
                    throw $_
                }
                Write-Verbose "Any property name collisions appear to have been resolved."
            }

            $response = $response.data

            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}

            $response
            #>
        }
    }
    end
    {
        if ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            $body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------

            if ($SortBy -xor $SortDirection) {
                throw 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.'
            }

            # Add sort direction to request body, if specified
            if ($SortDirection) {$body.Add('sortDirection',$SortDirection.TrimEnd('ending').ToLower())}

            # Add sort field to request body, if specified
            if ($SortBy) {
                if ($SortBy -eq 'LastSeen') {
                    $body.Add('sortField','lastSeen') # Patch to convert 'LastSeen' to 'lastSeen'
                }
                else {
                    $body.Add('sortField',$SortBy.ToLower())
                }
            }
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $filterSet = @() # Filter set array

            # Additional parameter validations and mutual exclusions
            if ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($External -and $Internal) {throw 'Cannot reconcile -External and -Internal switches. Use zero or one of these, but not both.'}

            # Value-mapped filters
            if ($AppName)    {$filterSet += @{'service'=@{'eq'=([int[]]($AppName | ForEach-Object {$_ -as [int]}))}}}
            if ($AppNameNot) {$filterSet += @{'service'=@{'neq'=([int[]]($AppNameNot | ForEach-Object {$_ -as [int]}))}}}

            # Simple filters
            if ($Internal)   {$filterSet += @{'affiliation'=   @{'eq'=$false}}}
            if ($External)   {$filterSet += @{'affiliation'=   @{'eq'=$true}}}
            if ($UserName)   {$filterSet += @{'entity'=        @{'eq'=$UserName}}}
            if ($AppId)      {$filterSet += @{'service'=       @{'eq'=$AppId}}}
            if ($AppIdNot)   {$filterSet += @{'service'=       @{'neq'=$AppIdNot}}}
            if ($UserDomain) {$filterSet += @{'domain'=        @{'eq'=$UserDomain}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/entities/" -Body $body -Method Post -FilterSet $filterSet -Raw
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }

            $response = $response.content

            # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
            try {
                $response = $response | ConvertFrom-Json
            }
            catch {
                Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                $response = $response.Replace('"Id":','"Id_int":')
                try {
                    $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                }
                catch {
                    throw $_
                }
                Write-Verbose "Any property name collisions appear to have been resolved."
            }

            $response = $response.data

            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}

            $response
        }
    }
}