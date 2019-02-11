<#
.Synopsis
   Gets alert information from your Cloud App Security tenant.
.DESCRIPTION
   Gets alert information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASAlert gets 100 alert records and associated properties. You can specify a particular alert GUID to fetch a single alert's information or you can pull a list of activities based on the provided filters.

   Get-MCASAlert returns a single custom PS Object or multiple PS Objects with all of the alert properties. Methods available are only those available to custom objects by default.
.EXAMPLE
    PS C:\> Get-MCASAlert -ResultSetSize 1

    This pulls back a single alert record and is part of the 'List' parameter set.

.EXAMPLE
    PS C:\> Get-MCASAlert -Identity 572caf4588011e452ec18ef0

    This pulls back a single alert record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
    PS C:\> (Get-MCASAlert -ResolutionStatus Open -Severity High | where{$_.title -match "system alert"}).descriptionTemplate.parameters.LOGRABBER_SYSTEM_ALERT_MESSAGE_BASE.functionObject.parameters.appName

    ServiceNow
    Box

    This command showcases the ability to expand nested tables of alerts. First, we pull back only Open alerts marked as High severity and filter down to only those with a title that matches "system alert". By wrapping the initial call in parentheses you can now extract the names of the affected services by drilling into the nested tables and referencing the appName property.

.FUNCTIONALITY
   Get-MCASAlert is intended to function as a query mechanism for obtaining alert information from Cloud App Security.
#>
function Get-MCASAlert {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        $Credential = $CASCredential,
        
        # Fetches an alert object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity,
        
        # Specifies the property by which to sort the results. Possible Values: 'Date','Severity', 'ResolutionStatus'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        #[ValidateSet('Date','Severity','ResolutionStatus')] # Additional sort fields removed by PG
        [ValidateSet('Date')]
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

        # Limits the results by severity. Possible Values: 'High','Medium','Low'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [severity_level[]]$Severity,

        # Limits the results to items with a specific resolution status. Possible Values: 'Open','Dismissed','Resolved'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [resolution_status[]]$ResolutionStatus,

        # Limits the results to items related to the specified user/users, such as 'alice@contoso.com','bob@contoso.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("User")]
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

        # Limits the results to items related to the specified policy ID, such as 57595d0ba6b5d8cd76d6be8c.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Policy,

        # Limits the results to items with a specific risk score. The valid range is 1-10.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(0,10)]
        [int[]]$Risk,

        # Limits the results to items from a specific source.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,

        # Limits the results to read items.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Read,

        # Limits the results to unread items.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Unread
    )
    begin {
    }
    process {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($PSCmdlet.ParameterSetName -eq 'Fetch')
        {
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/$Identity/" -Method Get
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
            }
            
            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}
            
            $response
        }
    }
    end {
        if ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            $body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------

            if ($SortBy -xor $SortDirection) {throw 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.'}

            # Add sort direction to request body, if specified
            if ($SortDirection) {$body.Add('sortDirection',$SortDirection.TrimEnd('ending').ToLower())}

            # Add sort field to request body, if specified
            if ($SortBy)
            {
                if ($SortBy -eq 'ResolutionStatus')
                {
                    $body.Add('sortField','status') # Patch to convert 'resolutionStatus' to 'status', because the API is not using them consistently, but we are
                }
                else
                {
                    $body.Add('sortField',$SortBy.ToLower())
                }
            }
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $filterSet = @() # Filter set array

            # Additional parameter validations and mutexes
            if ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($Read -and $Unread) {throw 'Cannot reconcile -Read and -Unread parameters. Only use one of them at a time.'}

            # Value-mapped filters
            if ($AppName)          {$filterSet += @{'entity.service'=   @{'eq'=([int[]]($AppName | ForEach-Object {$_ -as [int]}))}}}
            if ($AppNameNot)       {$filterSet += @{'entity.service'=   @{'neq'=([int[]]($AppNameNot | ForEach-Object {$_ -as [int]}))}}}
            if ($Severity)         {$filterSet += @{'severity'=         @{'eq'=([int[]]($Severity | ForEach-Object {$_ -as [int]}))}}}
            if ($ResolutionStatus) {$filterSet += @{'resolutionStatus'= @{'eq'=([int[]]($ResolutionStatus | ForEach-Object {$_ -as [int]}))}}}

            # Simple filters
            if ($UserName)   {$filterSet += @{'entity.user'=    @{'eq'=$UserName}}}
            if ($AppId)      {$filterSet += @{'entity.service'= @{'eq'=$AppId}}}
            if ($AppIdNot)   {$filterSet += @{'entity.service'= @{'neq'=$AppIdNot}}}
            if ($Policy)     {$filterSet += @{'entity.policy'=  @{'eq'=$Policy}}}
            if ($Risk)       {$filterSet += @{'risk'=           @{'eq'=$Risk}}}
            if ($AlertType)  {$filterSet += @{'id'=             @{'eq'=$AlertType}}}
            if ($Source)     {$filterSet += @{'source'=         @{'eq'=$Source}}}
            if ($Read)       {$filterSet += @{'read'=           @{'eq'=$true}}}
            if ($Unread)     {$filterSet += @{'read'=           @{'eq'=$false}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/alerts/" -Body $body -Method Post -FilterSet $filterSet
            }
            catch {
                throw "Error calling MCAS API. The exception was: $_"
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