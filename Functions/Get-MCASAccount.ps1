<#
.Synopsis
   Gets user account information from your Cloud App Security tenant.
.DESCRIPTION
   Gets user account information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASAccount gets 100 account records and associated properties. You can specify a particular account GUID to fetch a single account's information or you can pull a list of accounts based on the provided filters.

   Get-MCASAccount returns a single custom PS Object or multiple PS Objects with all of the account properties. Methods available are only those available to custom objects by default.
.EXAMPLE
   Get-MCASAccount -ResultSetSize 1

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
   (Get-MCASAccount -UserDomain contoso.com).count

    2

    This pulls back all accounts from the specified domain and returns a count of the returned objects.

.EXAMPLE
   Get-MCASAccount -Affiliation External | select @{N='Unique Domains'; E={$_.userDomain}} -Unique

    Unique Domains
    --------------
    gmail.com
    outlook.com
    yahoo.com

    This pulls back all accounts flagged as external to the domain and displays only unique records in a new property called 'Unique Domains'.

.EXAMPLE
   (Get-MCASAccount -ServiceNames 'Microsoft Cloud App Security').serviceData.20595

    email                              lastLogin                   lastSeen
    -----                              ---------                   --------
    admin@mod.onmicrosoft.com          2016-06-13T21:17:40.821000Z 2016-06-13T21:17:40.821000Z

    This queries for any Cloud App Security accounts and displays the serviceData table containing the email, last login, and last seen properties. 20595 is the Service ID for Cloud App Security.

.FUNCTIONALITY
    Get-MCASAccount is intended to function as a query mechanism for obtaining account information from Cloud App Security.
#>
function Get-MCASAccount
{
    [CmdletBinding()]
    [Alias('Get-CASAccount')]
    Param
    (
        # Fetches an account object by its unique identifier.
        # [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        # [ValidateNotNullOrEmpty()]
        # [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        # [alias("_id")]
        # [string]$Identity,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

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
    Begin
    {
        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
        # Fetch no longer works on the /accounts/ endpoint, so this was removed
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
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($External -and $Internal) {Throw 'Cannot reconcile -External and -Internal switches. Use zero or one of these, but not both.'}

            # Value-mapped filters
            If ($AppName)    {$FilterSet += @{'service'=@{'eq'=([int[]](($AppName | ForEach-Object {$_ -as [int]})))}}}
            If ($AppNameNot) {$FilterSet += @{'service'=@{'neq'=([int[]](($AppNameNot | ForEach-Object {$_ -as [int]})))}}}

            # Simple filters
            If ($Internal)   {$FilterSet += @{'affiliation'=   @{'eq'=$false}}}
            If ($External)   {$FilterSet += @{'affiliation'=   @{'eq'=$true}}}
            If ($UserName)   {$FilterSet += @{'user.username'= @{'eq'=$UserName}}}
            If ($AppId)      {$FilterSet += @{'service'=       @{'eq'=$AppId}}}
            If ($AppIdNot)   {$FilterSet += @{'service'=       @{'neq'=$AppIdNot}}}
            If ($UserDomain) {$FilterSet += @{'domain'=        @{'eq'=$UserDomain}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try {
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/accounts/" -Body $Body -Method Post -Token $Token -FilterSet $FilterSet
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            
            $Response = $Response.content

            Write-Verbose "Checking for property name collisions to handle"
            $Response = Edit-MCASPropertyName $Response -OldPropName '"Id":' -NewPropName '"Id_int":'

            $Response = $Response | ConvertFrom-Json

            # For list responses with zero results, set an empty collection as response rather than returning the response metadata
            If ($Response.total -eq 0) {
                $Response = @()
            }
            # For list responses, get the data property only
            Else {
                $Response = $Response.data
            }

            If (($Response | Get-Member).name -contains '_id') {
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru
            }

            $Response
        }
    }
}
