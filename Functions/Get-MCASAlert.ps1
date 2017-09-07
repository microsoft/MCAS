<#
.Synopsis
   Gets alert information from your Cloud App Security tenant.
.DESCRIPTION
   Gets alert information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASAlert gets 100 alert records and associated properties. You can specify a particular alert GUID to fetch a single alert's information or you can pull a list of activities based on the provided filters.

   Get-MCASAlert returns a single custom PS Object or multiple PS Objects with all of the alert properties. Methods available are only those available to custom objects by default.
.EXAMPLE
   Get-MCASAlert -ResultSetSize 1

    This pulls back a single alert record and is part of the 'List' parameter set.

.EXAMPLE
   Get-MCASAlert -Identity 572caf4588011e452ec18ef0

    This pulls back a single alert record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   (Get-MCASAlert -ResolutionStatus Open -Severity High | where{$_.title -match "system alert"}).descriptionTemplate.parameters.LOGRABBER_SYSTEM_ALERT_MESSAGE_BASE.functionObject.parameters.appName

    ServiceNow
    Box

    This command showcases the ability to expand nested tables of alerts. First, we pull back only Open alerts marked as High severity and filter down to only those with a title that matches "system alert". By wrapping the initial call in parentheses you can now extract the names of the affected services by drilling into the nested tables and referencing the appName property.

.FUNCTIONALITY
   Get-MCASAlert is intended to function as a query mechanism for obtaining alert information from Cloud App Security.
#>
function Get-MCASAlert
{
    [CmdletBinding()]
    [Alias('Get-CASAlert')]
    Param
    (
        # Fetches an alert object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

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
    Begin
    {
        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        If ($PSCmdlet.ParameterSetName -eq 'Fetch')
        {
            Try {
                # Fetch the item by its id
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/alerts/$Identity/" -Method Get -Token $Token
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

            $Response = $Response.content | ConvertFrom-Json
            
            If (($Response | Get-Member).name -contains '_id') {
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru
            }
            
            $Response
        }
    }
    End
    {
        If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            $Body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------

            If ($SortBy -xor $SortDirection) {Throw 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.'}

            # Add sort direction to request body, if specified
            If ($SortDirection) {$Body.Add('sortDirection',$SortDirection.TrimEnd('ending').ToLower())}

            # Add sort field to request body, if specified
            If ($SortBy)
            {
                If ($SortBy -eq 'ResolutionStatus')
                {
                    $Body.Add('sortField','status') # Patch to convert 'resolutionStatus' to 'status', because the API is not using them consistently, but we are
                }
                Else
                {
                    $Body.Add('sortField',$SortBy.ToLower())
                }
            }
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $FilterSet = @() # Filter set array

            # Additional parameter validations and mutexes
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($Read -and $Unread) {Throw 'Cannot reconcile -Read and -Unread parameters. Only use one of them at a time.'}

            # Value-mapped filters
            If ($AppName)          {$FilterSet += @{'entity.service'=   @{'eq'=([int[]]($AppName | ForEach-Object {$_ -as [int]}))}}}
            If ($AppNameNot)       {$FilterSet += @{'entity.service'=   @{'neq'=([int[]]($AppNameNot | ForEach-Object {$_ -as [int]}))}}}
            If ($Severity)         {$FilterSet += @{'severity'=         @{'eq'=([int[]]($Severity | ForEach-Object {$_ -as [int]}))}}}
            If ($ResolutionStatus) {$FilterSet += @{'resolutionStatus'= @{'eq'=([int[]]($ResolutionStatus | ForEach-Object {$_ -as [int]}))}}}

            # Simple filters
            If ($UserName)   {$FilterSet += @{'entity.user'=    @{'eq'=$UserName}}}
            If ($AppId)      {$FilterSet += @{'entity.service'= @{'eq'=$AppId}}}
            If ($AppIdNot)   {$FilterSet += @{'entity.service'= @{'neq'=$AppIdNot}}}
            If ($Policy)     {$FilterSet += @{'entity.policy'=  @{'eq'=$Policy}}}
            If ($Risk)       {$FilterSet += @{'risk'=           @{'eq'=$Risk}}}
            If ($AlertType)  {$FilterSet += @{'id'=             @{'eq'=$AlertType}}}
            If ($Source)     {$FilterSet += @{'source'=         @{'eq'=$Source}}}
            If ($Read)       {$FilterSet += @{'read'=           @{'eq'=$true}}}
            If ($Unread)     {$FilterSet += @{'read'=           @{'eq'=$false}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try {
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/alerts/" -Body $Body -Method Post -Token $Token -FilterSet $FilterSet
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

            $Response = $Response | ConvertFrom-Json
            
            $Response = Invoke-MCASResponseHandling -Response $Response

            $Response
        }
    }
}
