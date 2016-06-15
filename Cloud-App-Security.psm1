$ErrorActionPreference = 'Stop'

#region ----------------------------Value Maps----------------------------

$AppValueMap =              @{'Box'=10489;'Okta'=10980;'Salesforce'=11114;'Office 365'=11161;'Amazon Web Services'=11599;'Dropbox'=11627;'Google Apps'=11770;'ServiceNow'=14509;'Microsoft OneDrive for Business'=15600;'Microsoft Cloud App Security'=20595;'Microsoft Sharepoint Online'=20892;'Microsoft Exchange Online'=20893}

$IpCategoryValueMap =       @{'None'=0;'Internal'=1;'Administrative'=2;'Risky'=3;'VPN'=4;'Cloud Provider'=5}

$SeverityValueMap =         @{'High'=2;'Medium'=1;'Low'=0}

$ResolutionStatusValueMap = @{'Resolved'=2;'Dismissed'=1;'Open'=0}

$FileTypeValueMap =         @{'Other'=0;'Document'=1;'Spreadsheet'=2; 'Presentation'=3; 'Text'=4; 'Image'=5; 'Folder'=6}

$FileAccessLevelValueMap =  @{'Private'=0;'Internal'=1;'External'=2;'Public'=3;'PublicInternet'=4}

#endregion ----------------------------Value Maps----------------------------

function ConvertTo-CASJsonFilterString ($colFilters) # Private function that should not be exported
{
    $colTemp = @()
    ForEach ($f in $colFilters) {$colTemp += ((($f | ConvertTo-Json -Depth 2 -Compress).TrimEnd('}')).TrimStart('{'))} # Convert filter set to JSON and trim outer curly braces
    Write-Output ('{'+($colTemp -join '},')+'}}') # Touch up the string just a little and return it
}

<#
.Synopsis
   Gets user account information from your Cloud App Security tenant.
.DESCRIPTION
   Gets user account information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-CASAccount gets 100 account records and associated properties. You can specify a particular account GUID to fetch a single account's information or you can pull a list of accounts based on the provided filters.

   Get-CASAccount returns a single custom PS Object or multiple PS Objects with all of the account properties. Methods available are only those available to custom objects by default. 
.EXAMPLE
   Get-CASAccount -ResultSetSize 1

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
   Get-CASAccount -Identity 572caf4588011e452ec18ef0

    username         : alice@contoso.com
    consolidatedTags : {}
    userDomain       : contoso.com
    serviceData      : @{20595=}
    agents           : {}
    lastSeen         : 2016-05-13T20:23:47.210000Z
    _tid             : 17000616
    services         : {20595}
    _id              : 572caf4588011e452ec18ef0
    firstSeen        : 2016-05-06T14:50:44.762000Z
    external         : False
    Identity         : 572caf4588011e452ec18ef0

    This pulls back a single user record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   (Get-CASAccount -UserDomain contoso.com).count

    2

    This pulls back all accounts from the specified domain and returns a count of the returned objects.

.EXAMPLE
   Get-CASAccount -Affiliation External | select @{N='Unique Domains'; E={$_.userDomain}} -Unique 

    Unique Domains
    --------------
    gmail.com
    outlook.com
    yahoo.com

    This pulls back all accounts flagged as external to the domain and displays only unique records in a new property called 'Unique Domains'.

.EXAMPLE
   (Get-CASAccount -ServiceNames 'Microsoft Cloud App Security').serviceData.20595

    email                              lastLogin                   lastSeen
    -----                              ---------                   --------
    admin@mod.onmicrosoft.com          2016-06-13T21:17:40.821000Z 2016-06-13T21:17:40.821000Z

    This queries for any Cloud App Security accounts and displays the serviceData table containing the email, last login, and last seen properties. 20595 is the Service ID for Cloud App Security.

    .FUNCTIONALITY
       Get-CASAccount is intended to function as a query mechanism for obtaining account information from Cloud App Security.
#>
function Get-CASAccount
{
    [CmdletBinding()]
    Param
    (   
        # Fetches an account object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential,
 
        # Limits the results to external, if true, or internal users, if false
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [bool[]]$External,
        
        # Limits the results to items related to the specified user names, such as 'alice@contoso.com','bob@contoso.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$UserName,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppId")]
        [int[]]$Services,

        # Limits the results to items related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box','Okta','Salesforce','Office 365','Amazon Web Services','Dropbox','Google Apps','ServiceNow','Microsoft OneDrive for Business','Microsoft Cloud App Security','Microsoft Sharepoint Online','Microsoft Exchange Online')]
        [alias("AppName")]
        [string[]]$ServiceNames,

        # Limits the results to items not related to the specified service ids, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppIdNot")]
        [int[]]$ServicesNot,

        # Limits the results to items not related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box','Okta','Salesforce','Office 365','Amazon Web Services','Dropbox','Google Apps','ServiceNow','Microsoft OneDrive for Business','Microsoft Cloud App Security','Microsoft Sharepoint Online','Microsoft Exchange Online')]
        [alias("AppNameNot")]
        [string[]]$ServiceNamesNot,

        # Limits the results to items found in the specified user domains, such as 'contoso.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$UserDomain,

        # Specifies the property by which to sort the results. Possible Values: 'UserName','LastSeen'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Username','LastSeen')]
        [string]$SortBy,
                
        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results (up to 5000) to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,5000)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        If (!$TenantUri) # If -TenantUri specified, use it and skip these
        {
            If ($CASCredential) {$TenantUri = $CASCredential.GetNetworkCredential().username} # If well-known cred session var present, use it
            If ($Credential)                          {$TenantUri = $Credential.GetNetworkCredential().username} # If -Credential specfied, use it over the well-known cred session var
        }
        If (!$TenantUri) {Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop}
      
        If ($CASCredential) {$Token = $CASCredential.GetNetworkCredential().Password.ToLower()} # If well-known cred session var present, use it
        If ($Credential)                          {$Token = $Credential.GetNetworkCredential().Password.ToLower()} # If -Credential specfied, use it over the well-known cred session var
        If (!$Token) {Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop}
    }
    Process
    {        
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        If ($PSCmdlet.ParameterSetName -eq 'Fetch') 
        {        
            Try 
            {
                # Fetch the item by its id          
                $FetchResponse = (Invoke-WebRequest -Uri "https://$TenantUri/api/v1/accounts/$Identity/" -Headers @{Authorization = "Token $Token"} -Method Get -ErrorAction Stop) -replace '"Id":', '"Id_int":' | ConvertFrom-Json             
            }
            Catch 
            { 
                If ($_ -like 'The remote server returned an error: (404) Not Found.') 
                {
                    Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
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
            If ($FetchResponse) {Write-Output $FetchResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
    End
    {
        If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency
            
            $Body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------
        
            If ($SortBy -xor $SortDirection) {Write-Error 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.' -ErrorAction Stop}

            # Add sort direction to request body, if specified
            If ($SortDirection -eq 'Ascending')  {$Body.Add('sortDirection','asc')}
            If ($SortDirection -eq 'Descending') {$Body.Add('sortDirection','desc')}

            # Add sort field to request body, if specified
            If ($SortBy) 
            {
                If ($SortBy -eq 'LastSeen') 
                {
                    $Body.Add('sortField','lastSeen') # Patch to convert 'LastSeen' to 'lastSeen'
                } 
                Else
                {
                    $Body.Add('sortField',$SortBy.ToLower())
                }
            }  
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $FilterSet = @() # Filter set array

            # Additional parameter validations and mutual exclusions
            If ($ServiceNames    -and ($Services     -or $ServiceNamesNot -or $ServicesNot))  {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($Services        -and ($ServiceNames -or $ServiceNamesNot -or $ServicesNot))  {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($ServiceNamesNot -and ($Services     -or $ServiceNames    -or $ServicesNot))  {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($ServicesNot     -and ($Services     -or $ServiceNamesNot -or $ServiceNames)) {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            
            # Value-mapped filters
            If ($ServiceNames)    {$FilterSet += @{'service'=@{'eq'=($ServiceNames.GetEnumerator() | ForEach-Object {$AppValueMap.Get_Item($_)})}}}
            If ($ServiceNamesNot) {$FilterSet += @{'service'=@{'neq'=($ServiceNamesNot.GetEnumerator() | ForEach-Object {$AppValueMap.Get_Item($_)})}}}

            # Simple filters
            If ($External)    {$FilterSet += @{'affiliation'=   @{'eq'=$External}}}
            If ($UserName)    {$FilterSet += @{'user.username'= @{'eq'=$UserName}}}
            If ($Services)    {$FilterSet += @{'service'=       @{'eq'=$Services}}}
            If ($ServicesNot) {$FilterSet += @{'service'=       @{'neq'=$ServicesNot}}}
            If ($UserDomain)  {$FilterSet += @{'domain'=        @{'eq'=$UserDomain}}}
            
            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-CASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching alerts and handle errors
            Try 
            {
                $ListResponse = ((Invoke-WebRequest -Uri "https://$TenantUri/api/v1/accounts/" -Body $Body -Headers @{Authorization = "Token $Token"} -Method Post -ErrorAction Stop) -replace '"Id":', '"Id_int":' | ConvertFrom-Json).data              
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
            If ($ListResponse) {Write-Output $ListResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
}

<#
.Synopsis
   Gets user activity information from your Cloud App Security tenant.
.DESCRIPTION
   Gets user activity information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-CASActivity gets 100 activity records and associated properties. You can specify a particular activity GUID to fetch a single activity's information or you can pull a list of activities based on the provided filters.

   Get-CASActivity returns a single custom PS Object or multiple PS Objects with all of the activity properties. Methods available are only those available to custom objects by default. 
.EXAMPLE
   Get-CASActivity -ResultSetSize 1

    This pulls back a single activity record and is part of the 'List' parameter set.

.EXAMPLE
   Get-CASActivity -Identity 572caf4588011e452ec18ef0

    This pulls back a single activity record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   (Get-CASActivity -AppName Box).rawJson | ?{$_.event_type -match "upload"} | select ip_address -Unique

    ip_address
    ----------
    69.4.151.176
    98.29.2.44

    This grabs the last 100 Box activities, searches for an event type called "upload" in the rawJson table, and returns a list of unique IP addresses.

.FUNCTIONALITY
   Get-CASActivity is intended to function as a query mechanism for obtaining activity information from Cloud App Security.
#>
function Get-CASActivity
{
    [CmdletBinding()]
    Param
    (   
        # Fetches an activity object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateLength(20,20)]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential,

        # -User limits the results to items related to the specified user/users, for example 'alice@contoso.com','bob@contoso.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$User,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int[]]$AppId,

        # Limits the results to items related to the specified app names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box','Okta','Salesforce','Office 365','Amazon Web Services','Dropbox','Google Apps','ServiceNow','Microsoft OneDrive for Business','Microsoft Cloud App Security','Microsoft Sharepoint Online','Microsoft Exchange Online')]
        [string[]]$AppName,

        # Limits the results to items not related to the specified service ID's, for example 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int[]]$AppIdNot,
        
        # Limits the results to items not related to the specified app names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box','Okta','Salesforce','Office 365','Amazon Web Services','Dropbox','Google Apps','ServiceNow','Microsoft OneDrive for Business','Microsoft Cloud App Security','Microsoft Sharepoint Online','Microsoft Exchange Online')]
        [string[]]$AppNameNot,

        # Limits the results to items of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$EventTypeName,

        # Limits the results to items not of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$EventTypeNameNot,

        # Limits the results by ip category. Possible Values: 'None','Internal','Administrative','Risky','VPN','Cloud Provider'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('None','Internal','Administrative','Risky','VPN','Cloud Provider')]
        [string[]]$IpCategory,

        # Limits the results to items with the specified IP leading digits, such as 10.0.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateLength(1,45)]
        [string[]]$IpStartsWith,

        # Limits the results to items without the specified IP leading digits, such as 10.0.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateLength(1,45)]
        [string]$IpDoesNotStartWith,

        # Limits the results by device type. Possible Values: 'Desktop','Mobile','Tablet','Other'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Desktop','Mobile','Tablet','Other')]
        [string[]]$DeviceType,

        # Limits the results to admin events if true, non-admin events, if false.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [bool]$AdminEvents,

        # Specifies the property by which to sort the results. Possible Values: 'Date','Created'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Date','Created')]
        [string]$SortBy,
                
        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results (up to 10000) to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,10000)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        #$ErrorActionPreference = 'Stop'
        If (!$TenantUri) # If -TenantUri specified, use it and skip these
        {
            If ($CASCredential) {$TenantUri = $CASCredential.GetNetworkCredential().username} # If well-known cred session var present, use it
            If ($Credential)                          {$TenantUri = $Credential.GetNetworkCredential().username} # If -Credential specfied, use it over the well-known cred session var
        }
        If (!$TenantUri) {Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop}
      
        If ($CASCredential) {$Token = $CASCredential.GetNetworkCredential().Password.ToLower()} # If well-known cred session var present, use it
        If ($Credential)                          {$Token = $Credential.GetNetworkCredential().Password.ToLower()} # If -Credential specfied, use it over the well-known cred session var
        If (!$Token) {Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop}
    }
    Process
    {        
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        If ($PSCmdlet.ParameterSetName -eq 'Fetch') 
        {        
            Try 
            {
                # Fetch the activity by its id          
                $FetchResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/activities/$Identity/" -Headers @{Authorization = "Token $Token"} -Method Get -ErrorAction Stop             
            }
            Catch 
            { 
                If ($_ -like 'The remote server returned an error: (404) Not Found.') 
                {
                    Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
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
            If ($FetchResponse) {Write-Output $FetchResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
    End
    {
        If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency
            
            $Body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------
        
            If ($SortBy -xor $SortDirection) {Write-Error 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.' -ErrorAction Stop}

            # Add sort direction to request body, if specified
            If ($SortDirection -eq 'Ascending')  {$Body.Add('sortDirection','asc')}
            If ($SortDirection -eq 'Descending') {$Body.Add('sortDirection','desc')}

            # Add sort field to request body, if specified
            If ($SortBy) 
            {
                $Body.Add('sortField',$SortBy.ToLower())
            }  
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $FilterSet = @() # Filter set array

            # Additional parameter validations and mutual exclusions
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            
            # Value-mapped filters
            If ($IpCategory) {$FilterSet += @{'ip.category'=@{'eq'=($IpCategory.GetEnumerator() | ForEach-Object {$IpCategoryValueMap.Get_Item($_)})}}}
            If ($AppName)    {$FilterSet += @{'service'=    @{'eq'=($AppName.GetEnumerator() | ForEach-Object {$AppValueMap.Get_Item($_)})}}}
            If ($AppNameNot) {$FilterSet += @{'service'=    @{'neq'=($AppNameNot.GetEnumerator() | ForEach-Object {$AppValueMap.Get_Item($_)})}}}
            
            # Simple filters
            If ($User)                 {$FilterSet += @{'user.username'=       @{'eq'=$User}}}
            If ($AppId)                {$FilterSet += @{'service'=             @{'eq'=$AppId}}}
            If ($AppIdNot)             {$FilterSet += @{'service'=             @{'neq'=$AppIdNot}}}
            If ($EventTypeName)        {$FilterSet += @{'activity.actionType'= @{'eq'=$EventTypeName}}}
            If ($EventTypeNameNot)     {$FilterSet += @{'activity.actionType'= @{'neq'=$EventTypeNameNot}}}
            If ($DeviceType)           {$FilterSet += @{'device.type'=         @{'eq'=$DeviceType.ToUpper()}}} # CAS API expects upper case here
            If ($UserAgentContains)    {$FilterSet += @{'userAgent.userAgent'= @{'contains'=$UserAgentContains}}}
            If ($UserAgentNotContains) {$FilterSet += @{'userAgent.userAgent'= @{'ncontains'=$UserAgentNotContains}}}
            If ($IpStartsWith)         {$FilterSet += @{'ip.address'=          @{'startswith'=$IpStartsWith}}}
            If ($IpDoesNotStartWith)   {$FilterSet += @{'ip.address'=          @{'doesnotstartwith'=$IpStartsWith}}} 
            If ($AdminEvents)          {$FilterSet += @{'activity.type'=       @{'eq'=$AdminEvents}}}

            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-CASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching alerts and handle errors
            Try 
            {
                $ListResponse = (Invoke-RestMethod -Uri "https://$TenantUri/api/v1/activities/" -Body $Body -Headers @{Authorization = "Token $Token"} -Method Post -ErrorAction Stop).data              
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
            If ($ListResponse) {Write-Output $ListResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
}

<#
.Synopsis
   Gets alert information from your Cloud App Security tenant.
.DESCRIPTION
   Gets alert information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-CASAlert gets 100 alert records and associated properties. You can specify a particular alert GUID to fetch a single alert's information or you can pull a list of activities based on the provided filters.

   Get-CASAlert returns a single custom PS Object or multiple PS Objects with all of the alert properties. Methods available are only those available to custom objects by default. 
.EXAMPLE
   Get-CASAlert -ResultSetSize 1

    This pulls back a single alert record and is part of the 'List' parameter set.

.EXAMPLE
   Get-CASAlert -Identity 572caf4588011e452ec18ef0

    This pulls back a single alert record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   (Get-CASAlert -ResolutionStatus Open -Severity High | where{$_.title -match "system alert"}).descriptionTemplate.parameters.LOGRABBER_SYSTEM_ALERT_MESSAGE_BASE.functionObject.parameters.appName

    ServiceNow
    Box

    This command showcases the ability to expand nested tables of alerts. First, we pull back only Open alerts marked as High severity and filter down to only those with a title that matches "system alert". By wrapping the initial call in parentheses you can now extract the names of the affected services by drilling into the nested tables and referencing the appName property.

.FUNCTIONALITY
   Get-CASAlert is intended to function as a query mechanism for obtaining alert information from Cloud App Security.
#>
function Get-CASAlert
{
    [CmdletBinding()]
    Param
    (   
        # Fetches an alert object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential,

        # Limits the results by severity. Possible Values: 'High','Medium','Low'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('High','Medium','Low')]
        [string[]]$Severity,
        
        # Limits the results to items with a specific resolution status. Possible Values: 'Open','Dismissed','Resolved'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Open','Dismissed','Resolved')]
        [string[]]$ResolutionStatus,

        # Limits the results to items related to the specified user/users, such as 'alice@contoso.com','bob@contoso.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$User,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppId")]
        [int[]]$Service,

        # Limits the results to items related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box','Okta','Salesforce','Office 365','Amazon Web Services','Dropbox','Google Apps','ServiceNow','Microsoft OneDrive for Business','Microsoft Cloud App Security','Microsoft Sharepoint Online','Microsoft Exchange Online')]
        [alias("AppName")]
        [string[]]$ServiceName,

        # Limits the results to items not related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppIdNot")]
        [int[]]$ServiceNot,

        # Limits the results to items not related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box','Okta','Salesforce','Office 365','Amazon Web Services','Dropbox','Google Apps','ServiceNow','Microsoft OneDrive for Business','Microsoft Cloud App Security','Microsoft Sharepoint Online','Microsoft Exchange Online')]
        [alias("AppNameNot")]
        [string[]]$ServiceNameNot,

        # Limits the results to items related to the specified policy, such as 'Contoso CAS Policy'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$Policy,
        
        # Limits the results to items with a specific risk score. The valid range is 1-10. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(0,10)]
        [int[]]$Risk,
        
        # Limits the results to items from a specific source.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$Source,

        # Limits the results to read items, if true, unread items, if false.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [bool]$Read,

        # Specifies the property by which to sort the results. Possible Values: 'Date','Severity', 'ResolutionStatus'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Date','Severity','ResolutionStatus')]
        [string]$SortBy,
                
        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results (up to 10000) to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,10000)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        If (!$TenantUri) # If -TenantUri specified, use it and skip these
        {
            If ($CASCredential) {$TenantUri = $CASCredential.GetNetworkCredential().username} # If well-known cred session var present, use it
            If ($Credential)                          {$TenantUri = $Credential.GetNetworkCredential().username} # If -Credential specfied, use it over the well-known cred session var
        }
        If (!$TenantUri) {Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop}
      
        If ($CASCredential) {$Token = $CASCredential.GetNetworkCredential().Password.ToLower()} # If well-known cred session var present, use it
        If ($Credential)                          {$Token = $Credential.GetNetworkCredential().Password.ToLower()} # If -Credential specfied, use it over the well-known cred session var
        If (!$Token) {Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop}
    }
    Process
    {        
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        If ($PSCmdlet.ParameterSetName -eq 'Fetch') 
        {        
            Try 
            {
                # Fetch the item by its id          
                $FetchResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/alerts/$Identity/" -Headers @{Authorization = "Token $Token"} -Method Get -ErrorAction Stop             
            }
            Catch 
            { 
                If ($_ -like 'The remote server returned an error: (404) Not Found.') 
                {
                    Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
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
            If ($FetchResponse) {Write-Output $FetchResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
    End
    {
        If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency
            
            $Body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------
        
            If ($SortBy -xor $SortDirection) {Write-Error 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.' -ErrorAction Stop}

            # Add sort direction to request body, if specified
            If ($SortDirection -eq 'Ascending')  {$Body.Add('sortDirection','asc')}
            If ($SortDirection -eq 'Descending') {$Body.Add('sortDirection','desc')}

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

            # Additional parameter validations and mutual exclusions
            If ($ServiceName    -and ($Service     -or $ServiceNameNot -or $ServiceNot))  {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($Service        -and ($ServiceName -or $ServiceNameNot -or $ServiceNot))  {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($ServiceNameNot -and ($Service     -or $ServiceName    -or $ServiceNot))  {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($ServiceNot     -and ($Service     -or $ServiceNameNot -or $ServiceName)) {Write-Error 'Cannot reconcile service parameters. Only use one of them at a time.' -ErrorAction Stop}

            # Value-mapped filters
            If ($ServiceName)      {$FilterSet += @{'service'=         @{'eq'=($ServiceName.GetEnumerator()      | ForEach-Object {$AppValueMap.Get_Item($_)})}}}
            If ($ServiceNameNot)   {$FilterSet += @{'service'=         @{'neq'=($ServiceNameNot.GetEnumerator()  | ForEach-Object {$AppValueMap.Get_Item($_)})}}}
            If ($Severity)         {$FilterSet += @{'severity'=        @{'eq'=($Severity.GetEnumerator()         | ForEach-Object {$SeverityValueMap.Get_Item($_)})}}}
            If ($ResolutionStatus) {$FilterSet += @{'resolutionStatus'=@{'eq'=($ResolutionStatus.GetEnumerator() | ForEach-Object {$ResolutionStatusValueMap.Get_Item($_)})}}}

            # Simple filters
            If ($User)       {$FilterSet += @{'entity.user'=    @{'eq'=$User}}}
            If ($Service)    {$FilterSet += @{'entity.service'= @{'eq'=$Service}}}
            If ($ServiceNot) {$FilterSet += @{'entity.service'= @{'neq'=$ServiceNot}}}
            If ($Policy)     {$FilterSet += @{'entity.policy'=  @{'eq'=$Policy}}}
            If ($Risk)       {$FilterSet += @{'risk'=           @{'eq'=$Risk}}}
            If ($AlertType)  {$FilterSet += @{'id'=             @{'eq'=$AlertType}}}
            If ($Source)     {$FilterSet += @{'source'=         @{'eq'=$Source}}}
            If ($Read)       {$FilterSet += @{'read'=           @{'eq'=$Read}}}
 
            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-CASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching alerts and handle errors
            Try 
            {
                $ListResponse = (Invoke-RestMethod -Uri "https://$TenantUri/api/v1/alerts/" -Body $Body -Headers @{Authorization = "Token $Token"} -Method Post -ErrorAction Stop).data              
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
            If ($ListResponse) {Write-Output $ListResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
}

<#
.Synopsis
   Gets a credential to be used by other Cloud App Security module cmdlets.
.DESCRIPTION
   Get-CASCredential imports a set of credentials to be used by other Cloud App Security module cmdlets.

   When using Get-CASCredential you will be prompted to provide your Cloud App Security tenant URL as well as an OAuth Token that must be created manually in the console.

   Get-CASCredential takes the tenant URL and OAuth token and stores them in a special global session variable called $CASCredential and converts the OAuth token to a 64bit secure string while in memory.

   All CAS Module cmdlets reference that special global variable to pass requests to your Cloud App Security tenant.

   See the examples section for ways to automate setting your CAS credentials for the session.

.EXAMPLE
   Get-CASCredential

    This prompts the user to enter both their tenant URL as well as their OAuth token. 

    Username = Tenant URL without https:// (Example: contoso.portal.cloudappsecurity.com)
    Password = Tenant OAuth Token (Example: 432c1750f80d66a1cf2849afb6b10a7fcdf6738f5f554e32c9915fb006bd799a)

    C:\>$CASCredential

    To verify your credentials are set in the current session, run the above command.

    UserName                                 Password
    --------                                 --------
    contoso.portal.cloudappsecurity.com    System.Security.SecureString

.EXAMPLE
    Get-CASCredential -PassThru | Export-CliXml C:\Users\Alice\MyCASCred.credential -Force

    By specifying the -PassThru switch parameter, this will put the $CASCredential into the pipeline which can be exported to a .credential file that will store the tenant URL and encrypted version of the token in a file.

    We can use this newly created .credential file to automate setting our CAS credentials in the session by adding an import command to our profile.

    C:\>notepad $profile

    The above command will open our PowerShell profile, which is a set of commands that will run when we start a new session. By default it is empty.

    $CASCredential = Import-Clixml "C:\Users\Alice\MyCASCred.credential"

    By adding the above line to our profile and save, the next time we open a new PowerShell session, the credential file will automatically be imported into the $CASCredential which allows us to use other CAS cmdlets without running Get-CASCredential at the start of the session.

.FUNCTIONALITY
   Get-CASCredential is intended to import the CAS tenant URL and OAuth Token into a global session variable to allow other CAS cmdlets to authenticate when passing requests.
#>
function Get-CASCredential
{
    [CmdletBinding()]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies that the credential should be returned into the pipeline for further processing.
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    )
    Begin
    {
    }
    Process
    {
        # If tenant URI is specified, prompt for OAuth token and get it all into a global variable
        If ($TenantUri) {[System.Management.Automation.PSCredential]$Global:CASCredential = Get-Credential -UserName $TenantUri -Message "Enter the OAuth token for $TenantUri"}
   
        # Else, prompt for both the tenant and OAuth token and get it all into a global variable
        Else {[System.Management.Automation.PSCredential]$Global:CASCredential = Get-Credential -Message "Enter the CAS tenant and OAuth token"}

        # If -PassThru is specified, write the credential object to the pipeline (the global variable will also be exported to the calling session with Export-ModuleMember)
        If ($PassThru) {Write-Output $CASCredential}
    }
    End
    {
    }
}

<#
.Synopsis
   Gets file information from your Cloud App Security tenant.
.DESCRIPTION
   Gets file information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-CASFile gets 100 file records and associated properties. You can specify a particular file GUID to fetch a single file's information or you can pull a list of activities based on the provided filters.

   Get-CASFile returns a single custom PS Object or multiple PS Objects with all of the file properties. Methods available are only those available to custom objects by default. 
.EXAMPLE
   Get-CASFile -ResultSetSize 1

    This pulls back a single file record and is part of the 'List' parameter set.

.EXAMPLE
   Get-CASFile -Identity 572caf4588011e452ec18ef0

    This pulls back a single file record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   Get-CASFile -AppName Box -Extension pdf -Domains 'microsoft.com' | select name

    name                      dlpScanTime
    ----                      -----------
    pdf_creditcardnumbers.pdf 2016-06-08T19:00:36.534000Z
    mytestdoc.pdf             2016-06-12T22:00:45.235000Z
    powershellrules.pdf       2016-06-03T13:00:19.776000Z

    This searches Box files for any PDF documents owned by any user in the microsoft.com domain and returns the names of those documents and the last time they were scanned for DLP violations.

.FUNCTIONALITY
   Get-CASFile is intended to function as a query mechanism for obtaining file information from Cloud App Security.
#>
function Get-CASFile
{
    [CmdletBinding()]
    Param
    (   
        # Fetches a file object by its unique identifier. 
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential,

        # Limits the results to items of the specified file type. Possible Values: 'Other','Document','Spreadsheet', 'Presentation', 'Text', 'Image', 'Folder'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Other','Document','Spreadsheet', 'Presentation', 'Text', 'Image', 'Folder')]
        [string]$Filetype,

        # Limits the results to items not of the specified file type. Possible Values: 'Other','Document','Spreadsheet', 'Presentation', 'Text', 'Image', 'Folder'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Other','Document','Spreadsheet', 'Presentation', 'Text', 'Image', 'Folder')]
        [string]$FiletypeNot,
        
        # Limits the results to items of the specified sharing access level. Possible Values: 'Private','Internal','External','Public', 'PublicInternet'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Private','Internal','External','Public', 'PublicInternet')]
        [string[]]$FileAccessLevel,

        # Limits the results to items with the specified collaborator usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$Collaborators,

        # Limits the results to items without the specified collaborator usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$CollaboratorsNot,

        # Limits the results to items with the specified owner usernames, such as 'alice@contoso.com', 'bob@microsoft.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$Owner,

        # Limits the results to items without the specified owner usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$OwnerNot,

        # Limits the results to items with the specified MIME Type, such as 'text/plain', 'image/vnd.adobe.photoshop'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$MIMEType,

        # Limits the results to items without the specified MIME Type, such as 'text/plain', 'image/vnd.adobe.photoshop'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$MIMETypeNot,

        # Limits the results to items shared with the specified domains, such as 'contoso.com', 'microsoft.com'.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$Domains,

        # Limits the results to items not shared with the specified domains, such as 'contoso.com', 'microsoft.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string[]]$DomainsNot,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively). 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int[]]$AppId,

        # Limits the results to items not related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int[]]$AppIdNot,

        # Limits the results to items related to the specified service names, such as Microsoft OneDrive or Box. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box', 'Salesforce', 'Dropbox', 'Google Apps', 'ServiceNow', 'Microsoft OneDrive for Business', 'Microsoft Sharepoint Online')]
        [string[]]$AppName,

        # Limits the results to items not related to the specified service names, such as Microsoft OneDrive or Box. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Box', 'Salesforce', 'Dropbox', 'Google Apps', 'ServiceNow', 'Microsoft OneDrive for Business', 'Microsoft Sharepoint Online')]
        [string[]]$AppNameNot,

        # Limits the results to items with the specified file name with extension, such as 'My Microsoft File.txt'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$Name,

        # Limits the results to items with the specified file name without extension, such as 'My Microsoft File'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$NameWithoutExtension,

        # Limits the results to items with the specified file extensions, such as 'jpg', 'txt'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$Extension,

        # Limits the results to items without the specified file extensions, such as 'jpg', 'txt'.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$ExtensionNot,

        # Limits the results to items that CAS has marked as trashed, if true, not trashed, if false.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [bool]$Trashed,

        # Limits the results to items that CAS has marked as quarantined, if true, non-quarantined, if false.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [bool]$Quarantined,

        # Limits the results to items that CAS has marked as a folder, if true, non-folders, if false.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [bool]$Folder,

        # Specifies the property by which to sort the results. Possible Value: 'DateModified'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('DateModified')]
        [string]$SortBy,
                
        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results (up to 5000) to retrieve when listing items matching the specified filter criteria.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,5000)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        If (!$TenantUri) # If -TenantUri specified, use it and skip these
        {
            If ($CASCredential) {$TenantUri = $CASCredential.GetNetworkCredential().username} # If well-known cred session var present, use it
            If ($Credential)                          {$TenantUri = $Credential.GetNetworkCredential().username} # If -Credential specfied, use it over the well-known cred session var
        }
        If (!$TenantUri) {Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop}
      
        If ($CASCredential) {$Token = $CASCredential.GetNetworkCredential().Password.ToLower()} # If well-known cred session var present, use it
        If ($Credential)                          {$Token = $Credential.GetNetworkCredential().Password.ToLower()} # If -Credential specfied, use it over the well-known cred session var
        If (!$Token) {Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop}
    }
    Process
    {        
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        If ($PSCmdlet.ParameterSetName -eq 'Fetch') 
        {        
            Try 
            {
                # Fetch the item by its id          
                $FetchResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/files/$Identity/" -Headers @{Authorization = "Token $Token"} -Method Get -ErrorAction Stop             
            }
            Catch 
            { 
                If ($_ -like 'The remote server returned an error: (404) Not Found.') 
                {
                    Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
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
            If ($FetchResponse) {Write-Output $FetchResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }
    End
    {
        If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency
            
            $Body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

            #region ----------------------------SORTING----------------------------
        
            If ($SortBy -xor $SortDirection) {Write-Error 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.' -ErrorAction Stop}

            # Add sort direction to request body, if specified
            If ($SortDirection -eq 'Ascending')  {$Body.Add('sortDirection','asc')}
            If ($SortDirection -eq 'Descending') {$Body.Add('sortDirection','desc')}

            # Add sort field to request body, if specified
            If ($SortBy -eq 'DateModified') 
            {
                $Body.Add('sortField','dateModified') # Patch to convert 'DateModified' to 'dateModified' for API compatibility. There is only one Sort Field today.
            } 

            }  
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $FilterSet = @() # Filter set array

            # Additional parameter validations and mutual exclusions
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Write-Error 'Cannot reconcile app parameters. Only use one of them at a time.' -ErrorAction Stop}
            If ($Folder -and $FolderNot) {Write-Error 'Cannot reconcile -Folder and -FolderNot switches. Use zero or one of these, but not both.' -ErrorAction Stop}
            If ($Quarantined -and $QuarantinedNot) {Write-Error 'Cannot reconcile -Quarantined and -QuarantinedNot switches. Use zero or one of these, but not both.' -ErrorAction Stop}
            If ($Trashed -and $TrashedNot) {Write-Error 'Cannot reconcile -Trashed and -TrashedNot switches. Use zero or one of these, but not both.' -ErrorAction Stop}
            
            # Value-mapped filters
            If ($Filetype)        {$FilterSet += @{'fileType'=@{'eq'= ($Filetype.GetEnumerator()        | ForEach-Object {$FileTypeValueMap.Get_Item($_)})}}}
            If ($FiletypeNot)     {$FilterSet += @{'fileType'=@{'neq'=($FiletypeNot.GetEnumerator()     | ForEach-Object {$FileTypeValueMap.Get_Item($_)})}}}
            If ($FileAccessLevel) {$FilterSet += @{'sharing'= @{'eq'= ($FileAccessLevel.GetEnumerator() | ForEach-Object {$FileAccessLevelValueMap.Get_Item($_)})}}}
            If ($AppName)         {$FilterSet += @{'service'= @{'eq'= ($AppName.GetEnumerator()         | ForEach-Object {$AppValueMap.Get_Item($_)})}}}  
            If ($AppNameNot)      {$FilterSet += @{'service'= @{'neq'=($AppNameNot.GetEnumerator()      | ForEach-Object {$AppValueMap.Get_Item($_)})}}}  

            # Simple filters
            If ($AppId)                {$FilterSet += @{'service'=                  @{'eq'=$AppId}}}
            If ($AppIdNot)             {$FilterSet += @{'service'=                  @{'neq'=$AppIdNot}}}
            If ($Extension)            {$FilterSet += @{'extension'=                @{'eq'=$Extension}}}
            If ($ExtensionNot)         {$FilterSet += @{'extension'=                @{'neq'=$ExtensionNot}}}
            If ($Domains)              {$FilterSet += @{'collaborators.withDomain'= @{'eq'=$Domains}}}
            If ($DomainsNot)           {$FilterSet += @{'collaborators.withDomain'= @{'neq'=$DomainsNot}}}
            If ($Collaborators)        {$FilterSet += @{'collaborators.users'=      @{'eq'=$Collaborators}}}
            If ($CollaboratorsNot)     {$FilterSet += @{'collaborators.users'=      @{'neq'=$CollaboratorsNot}}}
            If ($Owner)                {$FilterSet += @{'owner.username'=           @{'eq'=$Owner}}}
            If ($OwnerNot)             {$FilterSet += @{'owner.username'=           @{'neq'=$OwnerNot}}}
            If ($MIMEType)             {$FilterSet += @{'mimeType'=                 @{'eq'=$MIMEType}}}
            If ($MIMETypeNot)          {$FilterSet += @{'mimeType'=                 @{'neq'=$MIMETypeNot}}}
            If ($Name)                 {$FilterSet += @{'filename'=                 @{'eq'=$Name}}}
            If ($NameWithoutExtension) {$FilterSet += @{'filename'=                 @{'text'=$NameWithoutExtension}}}
            If ($Folder)               {$FilterSet += @{'folder'=                   @{'eq'=$Folder}}}
            If ($Quarantined)          {$FilterSet += @{'quarantined'=              @{'eq'=$Quarantined}}} 
            If ($Trashed)              {$FilterSet += @{'trashed'=                  @{'eq'=$Trashed}}}
           
            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-CASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching alerts and handle errors
            Try 
            {
                $ListResponse = (Invoke-RestMethod -Uri "https://$TenantUri/api/v1/files/" -Body $Body -Headers @{Authorization = "Token $Token"} -Method Post -ErrorAction Stop).data              
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
            If ($ListResponse) {Write-Output $ListResponse | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru}
        }
    }

<#
.Synopsis
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
.DESCRIPTION
   Send-CASDiscoveryLog uploads an edge device log file to be analyzed for SaaS discovery by Cloud App Security.

   When using Send-CASDiscoveryLog, you must provide a log file by name/path and a log file type, which represents the source firewall or proxy device type. Also required is the name of the discovery data source with which the uploaded log should be associated; this can be created in the console.

   Send-CASDiscoveryLog does not return any value

.EXAMPLE
   Send-CASDiscoveryLog -LogFile C:\Users\Alice\MyFirewallLog.log -LogType CISCO_IRONPORT_PROXY -DiscoveryDataSource 'My CAS Discovery Data Source'

   This uploads the MyFirewallLog.log file to CAS for discovery, indicating that it is of the CISCO_IRONPORT_PROXY log format, and associates it with the data source name called 'My CAS Discovery Data Source'

.FUNCTIONALITY
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
#>
function Send-CASDiscoveryLog
{
    [CmdletBinding()]
    Param
    (
        # The full path of the Log File to be uploaded, such as 'C:\mylogfile.log'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Validatescript({Test-Path $_})]
        [string]$LogFile,
        
        # Specifies the source device type of the log file. Possible Values: 'BLUECOAT','CISCO_ASA','ZSCALER','FORTIGATE','PALO_ALTO','PALO_ALTO_SYSLOG','MCAFEE_SWG','CHECKPOINT','CISCO_SCAN_SAFE','CISCO_IRONPORT_PROXY','CHECKPOINT_OPSEC_LEA','SQUID','JUNIPER_SRX','SOPHOS_SG','MICROSOFT_ISA','WEBSENSE'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=1)]
        [ValidateSet('BLUECOAT','CISCO_ASA','ZSCALER','FORTIGATE','PALO_ALTO','PALO_ALTO_SYSLOG','MCAFEE_SWG','CHECKPOINT','CISCO_SCAN_SAFE','CISCO_IRONPORT_PROXY','CHECKPOINT_OPSEC_LEA','SQUID','JUNIPER_SRX','SOPHOS_SG','MICROSOFT_ISA','WEBSENSE')]
        [string]$LogType,
        
        # Specifies the discovery data source name as reflected in your CAS console, such as 'US West Microsoft ASA'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=2)]
        [string]$DiscoveryDataSource,
        
        # Specifies that the uploaded log file should be deleted after the upload operation completes.
        [alias("dts")]
        [switch]$Delete,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    Begin
    {
        If (!$TenantUri) # If -TenantUri specified, use it and skip these
        {
            If ($CASCredential) {$TenantUri = $CASCredential.GetNetworkCredential().username} # If well-known cred session var present, use it
            If ($Credential)                          {$TenantUri = $Credential.GetNetworkCredential().username} # If -Credential specfied, use it over the well-known cred session var
        }
        If (!$TenantUri) {Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop}
      
        If ($CASCredential) {$Token = $CASCredential.GetNetworkCredential().Password.ToLower()} # If well-known cred session var present, use it
        If ($Credential)                          {$Token = $Credential.GetNetworkCredential().Password.ToLower()} # If -Credential specfied, use it over the well-known cred session var
        If (!$Token) {Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop}
    }
    Process
    {   
        # Get just the file name, for when full path is specified
        Try
        {
            $FileName = (Get-Item $LogFile).Name
        }
        Catch
        {
            Write-Error "Could not get $LogFile : $_" -ErrorAction Stop    
        }

        #region GET UPLOAD URL
        Try 
        {       
            # Get an upload URL for the file
            $GetUploadUrlResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/discovery/upload_url/?filename=$FileName&source=$LogType" -Headers @{Authorization = "Token $Token"} -Method Get -ErrorAction Stop  

            $UploadUrl = $GetUploadUrlResponse.url           
        }
        Catch 
        { 
            If ($_ -like 'The remote server returned an error: (404) Not Found.') 
            {
                Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
            }
            ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
            {
                Write-Error '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
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
        #endregion GET UPLOAD URL

        #region UPLOAD LOG FILE
        
        # Set appropriate transfer encoding header info based on log file size
        If (($GetUploadUrlResponse.provider -eq 'azure') -and ($LogFileBlob.Length -le 64mb))
        {
            $FileUploadHeader = @{'x-ms-blob-type'='BlockBlob'}
        }
        ElseIf (($GetUploadUrlResponse.provider -eq 'azure') -and ($LogFileBlob.Length -gt 64mb))
        {
            $FileUploadHeader = @{'Transfer-Encoding'='chunked'}
        }
                    
        Try 
        {
            # Upload the log file to the target URL obtained earlier, using appropriate headers 
            If ($FileUploadHeader)
            {
                If (Test-Path $LogFile) {Invoke-RestMethod -Uri $UploadUrl -InFile $LogFile -Headers $FileUploadHeader -Method Put -ErrorAction Stop}
            }
            Else
            {
                If (Test-Path $LogFile) {Invoke-RestMethod -Uri $UploadUrl -InFile $LogFile -Method Put -ErrorAction Stop}
            }
        }
        Catch 
        { 
            If ($_ -like 'The remote server returned an error: (404) Not Found.') 
            {
                Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
            }
            ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
            {
                Write-Error '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
            }
            ElseIf ($_ -match "The remote name could not be resolved: ")
            {
                Write-Error "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
            }
            Else 
            {
                Write-Error "File upload failed: $_"
            }
        }
        #endregion UPLOAD LOG FILE

        #region FINALIZE UPLOAD 
        Try 
        {
            # Finalize the upload           
            $FinalizeUploadResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/discovery/done_upload/" -Headers @{Authorization = "Token $Token"} -Body @{'uploadUrl'=$UploadUrl;'inputStreamName'=$DiscoveryDataSource} -Method Post -ErrorAction Stop                
        }
        Catch 
        { 
            If ($_ -like 'The remote server returned an error: (404) Not Found.') 
            {
                Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
            }
            ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
            {
                Write-Error '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
            }
            ElseIf ($_ -match "The remote name could not be resolved: ")
            {
                Write-Error "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
            }
            ElseIf ($_ -match "The remote server returned an error: (400) Bad Request.")
            {
                Write-Error "400 - Bad Request: Ensure the -DiscoveryDataSource parameter specifies a valid data source name that you have created in the CAS web console."
            }
            Else 
            {
                Write-Error "Unknown exception when attempting to contact the Cloud App Security REST API: $_"
            }
        }
        #endregion FINALIZE UPLOAD

        Try 
        {
            # Delete the file           
            If ($Delete) {Remove-Item $LogFile -Force -ErrorAction Stop}            
        }
        Catch
        {
            Write-Error "Could not delete $LogFile : $_" -ErrorAction Stop
        }
    }
    End
    {
    }
}

<#
.Synopsis
   Sets the status of alerts in Cloud App Security.

.DESCRIPTION
   Sets the status of alerts in Cloud App Security and requires a credential be provided.

   There are two parameter sets: 

   MarkAs: Used for marking an alert as 'Read' or 'Unread'.
   Dismiss: Used for marking an alert as 'Dismissed'.

   An alert identity is always required to be specified either explicity or implicitly from the pipeline.

.EXAMPLE
   Set-CASAlert -Identity cac1d0ec5734e596e6d785cc -MarkAs Read

    This marks a single specified alert as 'Read'. 

.EXAMPLE
   Set-CASAlert -Identity cac1d0ec5734e596e6d785cc -Dismiss

    This will set the status of the specified alert as "Dismissed".

.EXAMPLE
   Get-CASAlert -Unread -SortBy Date -SortDirection Descending -ResultSetSize 10 | Set-CASAlert -MarkAs Read

    This will pull the last 10 alerts that were generated with a status of 'Unread' and will mark them all as 'Read'.

.FUNCTIONALITY
   Set-CASAlert is intended to function as a mechanism for setting the status of alerts Cloud App Security.
#>
function Set-CASAlert
{
    Param
    (
        # Specifies an alert object by its unique identifier.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies how to mark the alert. Possible Values: 'Read', 'Unread'.
        [Parameter(ParameterSetName='MarkAs',Mandatory=$true, Position=1)]
        [ValidateSet('Read','Unread')]
        [string]$MarkAs,

        # Specifies that the alert should be dismissed.
        [Parameter(ParameterSetName='Dismiss',Mandatory=$true)]
        [switch]$Dismiss,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    Begin
    {
        If (!$TenantUri) # If -TenantUri specified, use it and skip these
        {
            If ($CASCredential) {$TenantUri = $CASCredential.GetNetworkCredential().username} # If well-known cred session var present, use it
            If ($Credential)                          {$TenantUri = $Credential.GetNetworkCredential().username} # If -Credential specfied, use it over the well-known cred session var
        }
        If (!$TenantUri) {Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop}
      
        If ($CASCredential) {$Token = $CASCredential.GetNetworkCredential().Password.ToLower()} # If well-known cred session var present, use it
        If ($Credential)                          {$Token = $Credential.GetNetworkCredential().Password.ToLower()} # If -Credential specfied, use it over the well-known cred session var
        If (!$Token) {Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop}
    }
    Process
    {
        If ($Dismiss) {$Action = 'dismiss'}
        If ($MarkAs)  {$Action = $MarkAs.ToLower()} # Convert -MarkAs to lower case, as expected by the CAS API

        Try 
        {
            # Set the alert's state by its id          
            $SetResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/alerts/$Identity/$Action/" -Headers @{Authorization = "Token $Token"} -Method Post -ErrorAction Stop             
        }
        Catch 
        { 
            If ($_ -like 'The remote server returned an error: (404) Not Found.') 
            {
                Write-Error "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
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
    }
    End
    {
    }
}


# Vars to export
Export-ModuleMember -Variable CASCredential

# Cmdlets to export
Export-ModuleMember -Function Get-CASAccount
Export-ModuleMember -Function Get-CASActivity
Export-ModuleMember -Function Get-CASAlert
Export-ModuleMember -Function Get-CASCredential
Export-ModuleMember -Function Get-CASFile
Export-ModuleMember -Function Send-CASDiscoveryLog
Export-ModuleMember -Function Set-CASAlert