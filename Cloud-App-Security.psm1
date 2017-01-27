#$ErrorActionPreference = 'Stop'


#region ----------------------------Enum Types----------------------------

enum mcas_app
    {
    Box = 10489
    Okta = 10980
    Salesforce = 11114
    Office_365 = 11161
    Amazon_Web_Services = 11599
    Dropbox = 11627
    Google_Apps = 11770
    ServiceNow = 14509
    Microsoft_OneDrive_for_Business = 15600
    Microsoft_Cloud_App_Security = 20595
    Microsoft_Sharepoint_Online = 20892
    Microsoft_Exchange_Online = 20893
    }

enum device_type
    {
    BLUECOAT
    CHECKPOINT
    CISCO_ASA
    CISCO_IRONPORT_PROXY
    CISCO_SCAN_SAFE
    FORTIGATE
    JUNIPER_SRX
    MACHINE_ZONE_MERAKI
    MCAFEE_SWG
    MICROSOFT_ISA_W3C
    PALO_ALTO
    PALO_ALTO_SYSLOG
    SONICWALL_SYSLOG
    SOPHOS_SG
    SQUID
    SQUID_NATIVE
    WEBSENSE_SIEM_CEF
    WEBSENSE_V7_5
    ZSCALER
    }

enum ip_category
    {
    None = 0
    Internal = 1
    Administrative = 2
    Risky = 3
    VPN = 4
    Cloud_Provider = 5
    }

enum severity_level
    {
    High = 2
    Medium = 1
    Low = 0
    }

enum resolution_status
    {
    Resolved = 2
    Dismissed = 1
    Open = 0
    }

enum file_type
    {
    Other = 0
    Document = 1
    Spreadsheet = 2
    Presentation = 3
    Text = 4
    Image = 5
    Folder = 6
    }

enum file_access_level
    {
    Private = 0
    Internal = 1
    External = 2
    Public = 3
    PublicInternet = 4
    }

enum app_category
    {
    ACCOUNTING_AND_FINANCE
    ADVERTISING
    BUSINESS_MANAGEMENT
    CLOUD_STORAGE
    CODE_HOSTING
    COLLABORATION
    COMMUNICATIONS
    CONTENT_MANAGEMENT
    CONTENT_SHARING
    CRM
    CUSTOMER_SUPPORT
    DATA_ANALYTICS
    DEVELOPMENT_TOOLS
    ECOMMERCE
    EDUCATION
    FORUMS
    HEALTH
    HOSTING_SERVICES
    HUMAN_RESOURCE_MANAGEMENT
    IT_SERVICES
    MARKETING
    MEDIA
    NEWS_AND_ENTERTAINMENT
    ONLINE_MEETINGS
    OPERATIONS_MANAGEMENT
    PRODUCT_DESIGN
    PRODUCTIVITY
    PROJECT_MANAGEMENT
    PROPERTY_MANAGEMENT
    SALES
    SECURITY
    SOCIAL_NETWORK
    SUPLLY_CHAIN_AND_LOGISTICS
    TRANSPORTATION_AND_TRAVEL
    VENDOR_MANAGEMENT_SYSTEM
    WEB_ANALYTICS
    WEBMAIL
    WEBSITE_MONITORING
    }

<#
enum alert_type
    {
    ALERT_ADMIN_USER = 14680070
    ALERT_CABINET_EVENT_MATCH_AUDIT = 15728641
    ALERT_CABINET_EVENT_MATCH_FILE = 15728642
    ALERT_GEOLOCATION_NEW_COUNTRY = 196608
    ALERT_MANAGEMENT_DISCONNECTED_API = 15794945
    ALERT_SUSPICIOUS_ACTIVITY = 14680083   
    ALERT_COMPROMISED_ACCOUNT = 
    ALERT_DISCOVERY_ANOMALY_DETECTION = 
    ALERT_CABINET_INLINE_EVENT_MATCH = 
    ALERT_CABINET_EVENT_MATCH_OBJECT = 
    ALERT_CABINET_DISCOVERY_NEW_SERVICE = 
    ALERT_NEW_ADMIN_LOCATION = 
    ALERT_PERSONAL_USER_SAGE = 
    ALERT_ZOMBIE_USER = 
    }
#>

#endregion ----------------------------Enum Types----------------------------

#region ----------------------------Hash Tables---------------------------
$IPTagsList = @{
    Anonymous_Proxy = '000000030000000000000000'
    Botnet = '0000000c0000000000000000'
    Darknet_Scanning_IP = '0000001f0000000000000000'
    Exchange_Online = '0000000e0000000000000000'
    Exchange_Online_Protection = '000000150000000000000000'
    Malware_CnC_Server = '0000000d0000000000000000'
    Microsoft_Cloud = '0000001e0000000000000000'
    Microsoft_Authentication_and_Identity = '000000100000000000000000'
    Office_365 = '000000170000000000000000'
    Office_365_Planner = '000000190000000000000000'
    Office_365_ProPlus = '000000120000000000000000'
    Office_Online = '000000140000000000000000'
    Office_Sway = '0000001d0000000000000000'
    Office_Web_Access_Companion = '0000001a0000000000000000'
    OneNote = '000000130000000000000000'
    Remote_Connectivity_Analyzer = '0000001c0000000000000000'
    Satellite_Provider = '000000040000000000000000'
    SharePoint_Online = '0000000f0000000000000000'
    Skype_for_Business_Online = '000000180000000000000000'
    Smart_Proxy_and_Access_Proxy_Network = '000000050000000000000000'
    Tor = '2dfa95cd7922d979d66fcff5'
    Yammer = '0000001b0000000000000000'
    Zscaler = '000000160000000000000000'
    }

$ReportsList = @{
	'Activity by Location' = 'geolocation_summary/'
	'Browser Use' = 'browser_usage/'
	'IP Addresses' = 'ip_usage/'
	'IP Addresses for Admins' = 'ip_admin_usage/'
	'OS Use' = 'os_usage/'
	'Strictly Remote Users' = 'standalone_users/'
	'Cloud App Overview' = 'app_summary/'
	'Inactive Accounts' = 'zombie_users/'
	'Privileged Users' = 'admins/'
	'Salesforce Special Privileged Accounts' = 'sf_permissions/'
	'User Logon' = 'logins_rate/'
	'Data Sharing Overview' = 'files_summary/'
	'File Extensions' = 'file_extensions/'
	'Orphan Files' = 'orphan_files/'
	'Outbound Sharing by Domain' = 'external_domains/'
	'Owners of Shared Files' = 'shared_files_owners/'
	'Personal User Accounts' = 'personal_users/'
	'Sensitive File Names' = 'file_name_dlp/'
}

$GovernanceStatus = @{
    'Failed' = $false
    'Pending' = $null
    'Successful' = $true
}

$ActionList = @{
    
}


#endregion -------------------------Hash Tables---------------------------

#region ------------------------Internal Functions------------------------

function ConvertTo-MCASJsonFilterString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        $FilterSet
        )

    $Temp = @()
    
    ForEach ($Filter in $FilterSet) {
        $Temp += ((($Filter | ConvertTo-Json -Depth 2 -Compress).TrimEnd('}')).TrimStart('{')) 
        }
    $RawJsonFilter = ('{'+($Temp -join '},')+'}}')
    Write-Verbose "ConvertTo-MCASJsonFilterString: Converted filter set $FilterSet to JSON filter $RawJsonFilter"
    
    Write-Output $RawJsonFilter
    }

function Invoke-MCASRestMethod 
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$TenantUri,

        [Parameter(Mandatory=$true)]
        [ValidateSet('accounts','activities','alerts','discovery','files','governance')]
        [string]$Endpoint,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Get','Post','Put')]
        [string]$Method,        
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()] 
        [string]$EndpointSuffix,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()] 
        $Body,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$Token,

        [Switch]$Raw
        )
    Process
    {
        $Uri = "https://$TenantUri/api/v1/$Endpoint/"

        If ($EndpointSuffix) {
            $Uri += "$EndpointSuffix/"
            }

        Try {
        If ($Body) {
            $Response = Invoke-WebRequest -Uri $Uri -Body $Body -Headers @{Authorization = "Token $Token"} -Method $Method -UseBasicParsing -ErrorAction Stop
            }
        Else {   
            $Response = Invoke-WebRequest -Uri $Uri -Headers @{Authorization = "Token $Token"} -Method $Method -UseBasicParsing -ErrorAction Stop
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
                Write-Error "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid." -ErrorAction Stop
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
        # Windows/Powershell case insensitivity causes collision of 'id' (string) and 'Id' (integer) properties, so this patches the problem by adding _int to the integer Id property for accounts
        If ($Endpoint -eq 'accounts' -and $Response -ccontains '"Id":') {
            $Response = $Response -replace '"Id":', '"Id_int":'
            Write-Verbose "Invoke-MCASRestMethod: A property name collision was detected in the response from MCAS REST API $Endpoint endpoint for the following property names; 'id' and 'Id'. The 'Id' property was renamed to 'Id_int'."
            }
    
        # Convert from JSON to Powershell objects
        $Response = $Response | ConvertFrom-Json

        # For list responses, we need the data property only
        If ($Response.data) {
            $Response = $Response.data
            }

        # Add 'Identity' alias property, when appropriate
        If ($Response._id) {
            $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru
            }
    
        $Response
        }
    }
}

function Select-MCASTenantUri
{       
    If ($TenantUri) {
        $TenantUri
        }
    ElseIf ($Credential) {
        $Credential.GetNetworkCredential().username
        }
    ElseIf ($CASCredential) {
        $CASCredential.GetNetworkCredential().username
        }
    Else {
        Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop
        }
}

function Select-MCASToken
{
    If ($Credential) {
        $Credential.GetNetworkCredential().Password.ToLower()
        }
    ElseIf ($CASCredential) {
        $CASCredential.GetNetworkCredential().Password.ToLower()
        }
    Else {
        Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop
        }
}

#endregion ------------------------Internal Functions------------------------

#region ------------------------------Cmdlets-----------------------------

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
   Get-MCASAccount -Identity 572caf4588011e452ec18ef0

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
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,
 
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
        [alias("AppId")]
        [ValidateNotNullOrEmpty()]
        [int[]]$Services,

        # Limits the results to items related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppName")]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$ServiceNames,

        # Limits the results to items not related to the specified service ids, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [alias("AppIdNot")]
        [int[]]$ServicesNot,

        # Limits the results to items not related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppNameNot")]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$ServiceNamesNot,

        # Limits the results to items found in the specified user domains, such as 'contoso.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
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
        [int]$ResultSetSize = 5000,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        $Endpoint = 'accounts'
        
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
            Try 
            {
                # Fetch the item by its id
                $FetchResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix $Identity -Method Post -Token $Token
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $FetchResponse
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
            If ($ServiceNames    -and ($Services     -or $ServiceNamesNot -or $ServicesNot))  {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($Services        -and ($ServiceNames -or $ServiceNamesNot -or $ServicesNot))  {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($ServiceNamesNot -and ($Services     -or $ServiceNames    -or $ServicesNot))  {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($ServicesNot     -and ($Services     -or $ServiceNamesNot -or $ServiceNames)) {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($External -and $Internal) {Throw 'Cannot reconcile -External and -Internal switches. Use zero or one of these, but not both.'}

            # Value-mapped filters
            If ($ServiceNames)    {$FilterSet += @{'service'=@{'eq'=($ServiceNames | ForEach {$_ -as [int]})}}}
            If ($ServiceNamesNot) {$FilterSet += @{'service'=@{'neq'=($ServiceNamesNot | ForEach {$_ -as [int]})}}}

            # Simple filters
            If ($Internal)    {$FilterSet += @{'affiliation'=   @{'eq'=$false}}}
            If ($External)    {$FilterSet += @{'affiliation'=   @{'eq'=$true}}}
            If ($UserName)    {$FilterSet += @{'user.username'= @{'eq'=$UserName}}}
            If ($Services)    {$FilterSet += @{'service'=       @{'eq'=$Services}}}
            If ($ServicesNot) {$FilterSet += @{'service'=       @{'neq'=$ServicesNot}}}
            If ($UserDomain)  {$FilterSet += @{'domain'=        @{'eq'=$UserDomain}}}
            
            # boolean filters
            #If ($External -ne $null) {$FilterSet += @{'affiliation'= @{'eq'=$External}}}

            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-MCASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try 
            {
                $ListResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -Body $Body -Method Post -Token $Token                    
            }
                Catch 
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $ListResponse
        }
    }
}

<#
.Synopsis
   Gets user activity information from your Cloud App Security tenant.
.DESCRIPTION
   Gets user activity information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASActivity gets 100 activity records and associated properties. You can specify a particular activity GUID to fetch a single activity's information or you can pull a list of activities based on the provided filters.

   Get-MCASActivity returns a single custom PS Object or multiple PS Objects with all of the activity properties. Methods available are only those available to custom objects by default. 
.EXAMPLE
   Get-MCASActivity -ResultSetSize 1

    This pulls back a single activity record and is part of the 'List' parameter set.

.EXAMPLE
   Get-MCASActivity -Identity 572caf4588011e452ec18ef0

    This pulls back a single activity record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   (Get-MCASActivity -AppName Box).rawJson | ?{$_.event_type -match "upload"} | select ip_address -Unique

    ip_address
    ----------
    69.4.151.176
    98.29.2.44

    This grabs the last 100 Box activities, searches for an event type called "upload" in the rawJson table, and returns a list of unique IP addresses.

.FUNCTIONALITY
   Get-MCASActivity is intended to function as a query mechanism for obtaining activity information from Cloud App Security.
#>
function Get-MCASActivity
{
    [CmdletBinding()]
    [Alias('Get-CASActivity')]
    Param
    (   
        # Fetches an activity object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern("((\d{8}_\d{5}_[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})|([A-Za-z0-9]{20}))")]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # -User limits the results to items related to the specified user/users, for example 'alice@contoso.com','bob@contoso.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$User,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int[]]$AppId,

        # Limits the results to items related to the specified app names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$AppName,
        
        # Limits the results to items not related to the specified service ID's, for example 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int[]]$AppIdNot,
        
        # Limits the results to items not related to the specified app names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$AppNameNot,

        # Limits the results to items of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$EventTypeName,

        # Limits the results to items not of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$EventTypeNameNot,

        # Limits the results by ip category. Possible Values: 'None','Internal','Administrative','Risky','VPN','Cloud_Provider'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ip_category[]]$IpCategory,

        # Limits the results to items with the specified IP leading digits, such as 10.0.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateLength(1,45)]
        [string[]]$IpStartsWith,

        # Limits the results to items without the specified IP leading digits, such as 10.0.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateLength(1,45)]
        [string]$IpDoesNotStartWith,
        
        # Limits the results to items found before specified date. Use Get-Date.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateBefore,

        # Limits the results to items found after specified date. Use Get-Date.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateAfter,
        
        # Limits the results by device type. Possible Values: 'Desktop','Mobile','Tablet','Other'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Desktop','Mobile','Tablet','Other')]
        [string[]]$DeviceType,

        # Limits the results by performing a free text search
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()] 
        [string]$Text,

        # Limits the results to events listed for the specified File ID.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\b[A-Za-z0-9]{24}\b")] 
        [string]$FileID,

        # Limits the results to events listed for the specified API classification label. Use ^ when denoting (external) labels. Example: @("^Private")
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()] 
        [array]$FileLabel,

        # Limits the results to events listed for the specified IP Tags.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()] 
        [validateset("Anonymous_Proxy","Botnet","Darknet_Scanning_IP","Exchange_Online","Exchangnline_Protection","Malware_CnC_Server","Microsoft_Cloud","Microsoft_Authentication_and_Identity","Office_365","Office_365_Planner","Office_365_ProPlus","Office_Online","Office_Sway","Office_Web_Access_Companion","OneNote","Remote_Connectivity_Analyzer","Satellite_Provider","SharePoint_Online","Skype_for_Business_Online","Smart_Proxy_and_Access_Proxy_Network","Tor","Yammer","Zscaler")]
        [string[]]$IPTag,

        # Limits the results to items occuring in the last x number of days.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,180)] 
        [int]$DaysAgo,

        # Limits the results to admin events if specified.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$AdminEvents,

        # Limits the results to non-admin events if specified.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$NonAdminEvents,

        # Limits the results to impersonated events if specified.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Impersonated,

        # Limits the results to non-impersonated events if specified.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$ImpersonatedNot,

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
        [int]$ResultSetSize = 10000,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        $Endpoint = 'activities'

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
            Try 
            {
                # Fetch the item by its id
                $FetchResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix $Identity -Method Post -Token $Token
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $FetchResponse
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

            # Additional function for date conversion to unix format.
            If ($DateBefore) {$DateBefore2 = ([int](Get-Date -Date $DateBefore -UFormat %s)*1000)}
            If ($DateAfter) {$DateAfter2 = ([int](Get-Date -Date $DateAfter -UFormat %s)*1000)}

            # Additional parameter validations and mutual exclusions
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If (($DateBefore -and $DateAfter) -or ($DateBefore -and $DaysAgo) -or ($DateAfter -and $DaysAgo)){Throw 'Cannot reconcile app parameters. Only use one date parameter.'}
            If ($Impersonated -and $ImpersonatedNot){Throw 'Cannot reconcile app parameters. Do not combine Impersonated and ImpersonatedNot parameters.'}

            # Value-mapped filters
            If ($IpCategory) {$FilterSet += @{'ip.category'=@{'eq'=($IpCategory | ForEach {$_ -as [int]})}}}
            If ($AppName)    {$FilterSet += @{'service'=    @{'eq'=($AppName | ForEach {$_ -as [int]})}}}
            If ($AppNameNot) {$FilterSet += @{'service'=    @{'neq'=($AppNameNot | ForEach {$_ -as [int]})}}}
            If ($IPTag)      {$FilterSet += @{'ip.tags'=    @{'eq'=($IPTag.GetEnumerator() | ForEach {$IPTagsList.$_ -join ','})}}}

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
            If ($Text)                 {$FilterSet += @{'text'=                @{'text'=$Text}}} 
            If ($DaysAgo)              {$FilterSet += @{'date'=                @{'gte_ndays'=$DaysAgo}}} 
            If ($Impersonated)         {$FilterSet += @{'activity.impersonated' = @{'eq'=$true}}}
            If ($ImpersonatedNot)      {$FilterSet += @{'activity.impersonated' = @{'eq'=$false}}}
            If ($FileID)               {$FilterSet += @{'fileSelector'=        @{'eq'=$FileID}}}
            If ($FileLabel)            {$FilterSet += @{'fileLabels'=          @{'eq'=$FileLabel}}}
            If ($DateBefore -and (-not $DateAfter)) {$FilterSet += @{'date'= @{'lte'=$DateBefore2}}}
            If ($DateAfter -and (-not $DateBefore)) {$FilterSet += @{'date'= @{'gte'=$DateAfter2}}}

            # boolean filters
            If ($AdminEvents)    {$FilterSet += @{'activity.type'= @{'eq'=$true}}}
            If ($NonAdminEvents) {$FilterSet += @{'activity.type'= @{'eq'=$false}}}

            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-MCASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try 
            {
                $ListResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -Body $Body -Method Post -Token $Token                    
            }
                Catch 
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $ListResponse
        }
    }
}

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
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

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
        [string[]]$User,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppId")]
        [ValidateNotNullOrEmpty()]
        [int[]]$Service,

        # Limits the results to items related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppName")]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$ServiceName,

        # Limits the results to items not related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [alias("AppIdNot")]
        [int[]]$ServiceNot,

        # Limits the results to items not related to the specified service names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [alias("AppNameNot")]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$ServiceNameNot,

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
        [switch]$Unread,

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
        [int]$ResultSetSize = 10000,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        $Endpoint = 'alerts'

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
            Try 
            {
                # Fetch the item by its id
                $FetchResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix $Identity -Method Post -Token $Token
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $FetchResponse
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

            # Additional parameter validations and mutexes
            If ($ServiceName    -and ($Service     -or $ServiceNameNot -or $ServiceNot))  {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($Service        -and ($ServiceName -or $ServiceNameNot -or $ServiceNot))  {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($ServiceNameNot -and ($Service     -or $ServiceName    -or $ServiceNot))  {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($ServiceNot     -and ($Service     -or $ServiceNameNot -or $ServiceName)) {Throw 'Cannot reconcile service parameters. Only use one of them at a time.'}
            If ($Read -and $Unread) {Throw 'Cannot reconcile -Read and -Unread parameters. Only use one of them at a time.'}

            # Value-mapped filters
            If ($ServiceName)      {$FilterSet += @{'entity.service'=         @{'eq'=($ServiceName | ForEach {$_ -as [int]})}}}
            If ($ServiceNameNot)   {$FilterSet += @{'entity.service'=         @{'neq'=($ServiceNameNot | ForEach {$_ -as [int]})}}}
            If ($Severity)         {$FilterSet += @{'severity'=        @{'eq'=($Severity | ForEach {$_ -as [int]})}}}
            If ($ResolutionStatus) {$FilterSet += @{'resolutionStatus'=@{'eq'=($ResolutionStatus | ForEach {$_ -as [int]})}}}

            # Simple filters
            If ($User)       {$FilterSet += @{'entity.user'=    @{'eq'=$User}}}
            If ($Service)    {$FilterSet += @{'entity.service'= @{'eq'=$Service}}}
            If ($ServiceNot) {$FilterSet += @{'entity.service'= @{'neq'=$ServiceNot}}}
            If ($Policy)     {$FilterSet += @{'entity.policy'=  @{'eq'=$Policy}}}
            If ($Risk)       {$FilterSet += @{'risk'=           @{'eq'=$Risk}}}
            If ($AlertType)  {$FilterSet += @{'id'=             @{'eq'=$AlertType}}}
            If ($Source)     {$FilterSet += @{'source'=         @{'eq'=$Source}}}
            If ($Read)       {$FilterSet += @{'read'=           @{'eq'=$true}}}
            If ($Unread)     {$FilterSet += @{'read'=           @{'eq'=$false}}}
 
 
            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-MCASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try 
            {
                $ListResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -Body $Body -Method Post -Token $Token                    
            }
                Catch 
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $ListResponse
        }
    }
}

<#
.Synopsis
   Gets a credential to be used by other Cloud App Security module cmdlets.
.DESCRIPTION
   Get-MCASCredential imports a set of credentials to be used by other Cloud App Security module cmdlets.

   When using Get-MCASCredential you will be prompted to provide your Cloud App Security tenant URL as well as an OAuth Token that must be created manually in the console.

   Get-MCASCredential takes the tenant URL and OAuth token and stores them in a special global session variable called $CASCredential and converts the OAuth token to a 64bit secure string while in memory.

   All CAS Module cmdlets reference that special global variable to pass requests to your Cloud App Security tenant.

   See the examples section for ways to automate setting your CAS credentials for the session.

.EXAMPLE
   Get-MCASCredential

    This prompts the user to enter both their tenant URL as well as their OAuth token. 

    Username = Tenant URL without https:// (Example: contoso.portal.cloudappsecurity.com)
    Password = Tenant OAuth Token (Example: 432c1750f80d66a1cf2849afb6b10a7fcdf6738f5f554e32c9915fb006bd799a)

    C:\>$CASCredential

    To verify your credentials are set in the current session, run the above command.

    UserName                                 Password
    --------                                 --------
    contoso.portal.cloudappsecurity.com    System.Security.SecureString

.EXAMPLE
    Get-MCASCredential -PassThru | Export-CliXml C:\Users\Alice\MyCASCred.credential -Force

    By specifying the -PassThru switch parameter, this will put the $CASCredential into the pipeline which can be exported to a .credential file that will store the tenant URL and encrypted version of the token in a file.

    We can use this newly created .credential file to automate setting our CAS credentials in the session by adding an import command to our profile.

    C:\>notepad $profile

    The above command will open our PowerShell profile, which is a set of commands that will run when we start a new session. By default it is empty.

    $CASCredential = Import-Clixml "C:\Users\Alice\MyCASCred.credential"

    By adding the above line to our profile and save, the next time we open a new PowerShell session, the credential file will automatically be imported into the $CASCredential which allows us to use other CAS cmdlets without running Get-MCASCredential at the start of the session.

.FUNCTIONALITY
   Get-MCASCredential is intended to import the CAS tenant URL and OAuth Token into a global session variable to allow other CAS cmdlets to authenticate when passing requests.
#>
function Get-MCASCredential
{
    [CmdletBinding()]
    [Alias('Get-CASCredential')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies that the credential should be returned into the pipeline for further processing.
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    )
    Process
    {
        # If tenant URI is specified, prompt for OAuth token and get it all into a global variable
        If ($TenantUri) {[System.Management.Automation.PSCredential]$Global:CASCredential = Get-Credential -UserName $TenantUri -Message "Enter the OAuth token for $TenantUri"}
   
        # Else, prompt for both the tenant and OAuth token and get it all into a global variable
        Else {[System.Management.Automation.PSCredential]$Global:CASCredential = Get-Credential -Message "Enter the CAS tenant and OAuth token"}

        # If -PassThru is specified, write the credential object to the pipeline (the global variable will also be exported to the calling session with Export-ModuleMember)
        If ($PassThru) {Write-Output $CASCredential}
    }
}

<#
.Synopsis
   Gets file information from your Cloud App Security tenant.
.DESCRIPTION
   Gets file information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASFile gets 100 file records and associated properties. You can specify a particular file GUID to fetch a single file's information or you can pull a list of activities based on the provided filters.

   Get-MCASFile returns a single custom PS Object or multiple PS Objects with all of the file properties. Methods available are only those available to custom objects by default. 
.EXAMPLE
   Get-MCASFile -ResultSetSize 1

    This pulls back a single file record and is part of the 'List' parameter set.

.EXAMPLE
   Get-MCASFile -Identity 572caf4588011e452ec18ef0

    This pulls back a single file record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
   Get-MCASFile -AppName Box -Extension pdf -Domains 'microsoft.com' | select name

    name                      dlpScanTime
    ----                      -----------
    pdf_creditcardnumbers.pdf 2016-06-08T19:00:36.534000Z
    mytestdoc.pdf             2016-06-12T22:00:45.235000Z
    powershellrules.pdf       2016-06-03T13:00:19.776000Z

    This searches Box files for any PDF documents owned by any user in the microsoft.com domain and returns the names of those documents and the last time they were scanned for DLP violations.

.FUNCTIONALITY
   Get-MCASFile is intended to function as a query mechanism for obtaining file information from Cloud App Security.
#>
function Get-MCASFile
{
    [CmdletBinding()]
    [Alias('Get-CASFile')]
    Param
    (   
        <# Fetches a file object by its unique identifier. 
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,
        #>
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Limits the results to items of the specified file type. Value Map: 0 = Other,1 = Document,2 = Spreadsheet, 3 = Presentation, 4 = Text, 5 = Image, 6 = Folder.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [file_type[]]$Filetype,

        # Limits the results to items not of the specified file type. Value Map: 0 = Other,1 = Document,2 = Spreadsheet, 3 = Presentation, 4 = Text, 5 = Image, 6 = Folder.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [file_type[]]$FiletypeNot,
        
        # Limits the results to items of the specified sharing access level. Possible Values: 'Private','Internal','External','Public', 'PublicInternet'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [file_access_level[]]$FileAccessLevel,

        # Limits the results to items with the specified collaborator usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Collaborators,

        # Limits the results to items without the specified collaborator usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$CollaboratorsNot,

        # Limits the results to items with the specified owner usernames, such as 'alice@contoso.com', 'bob@microsoft.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Owner,

        # Limits the results to items without the specified owner usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$OwnerNot,

        # Limits the results to items with the specified MIME Type, such as 'text/plain', 'image/vnd.adobe.photoshop'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$MIMEType,

        # Limits the results to items without the specified MIME Type, such as 'text/plain', 'image/vnd.adobe.photoshop'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$MIMETypeNot,

        # Limits the results to items shared with the specified domains, such as 'contoso.com', 'microsoft.com'.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Domains,

        # Limits the results to items not shared with the specified domains, such as 'contoso.com', 'microsoft.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$DomainsNot,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively). 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int[]]$AppId,

        # Limits the results to items not related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int[]]$AppIdNot,

        # Limits the results to items related to the specified service names, such as Microsoft OneDrive or Box. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$AppName,

        # Limits the results to items not related to the specified service names, such as Microsoft OneDrive or Box. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$AppNameNot,

        # Limits the results to items with the specified file name with extension, such as 'My Microsoft File.txt'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # Limits the results to items with the specified file name without extension, such as 'My Microsoft File'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$NameWithoutExtension,

        # Limits the results to items with the specified file extensions, such as 'jpg', 'txt'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Extension,

        # Limits the results to items without the specified file extensions, such as 'jpg', 'txt'.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$ExtensionNot,

        # Limits the results to items that CAS has marked as trashed.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Trashed,

        # Limits the results to items that CAS has marked as not trashed.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$TrashedNot,

        # Limits the results to items that CAS has marked as quarantined.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Quarantined,
        
        # Limits the results to items that CAS has marked as not quarantined.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$QuarantinedNot,

        # Limits the results to items that CAS has marked as a folder.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$Folders,

        # Limits the results to items that CAS has marked as not a folder.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [switch]$FoldersNot,

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
        [int]$ResultSetSize = 5000,

        # Specifies the number of records, from the beginning of the result set, to skip.  
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        $Endpoint = 'files'
        
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
            Try 
            {
                # Fetch the item by its id
                $FetchResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix $Identity -Method Post -Token $Token
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $FetchResponse
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

            # Additional Hash Tables for Filetype & FiletypeNot Filters
            If ($Filetype){
                $Filetypehashtable = @{}
                $Filetype | ForEach {$Filetypehashtable.Add($_,$_)}
                }
            If ($FiletypeNot){
                $Filetypehashtable = @{}
                $FiletypeNot | ForEach {$Filetypehashtable.Add($_,$_)}
                }
                

            # Additional parameter validations and mutual exclusions
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($Folders -and $FoldersNot) {Throw 'Cannot reconcile -Folder and -FolderNot switches. Use zero or one of these, but not both.'}
            If ($Quarantined -and $QuarantinedNot) {Throw 'Cannot reconcile -Quarantined and -QuarantinedNot switches. Use zero or one of these, but not both.'}
            If ($Trashed -and $TrashedNot) {Throw 'Cannot reconcile -Trashed and -TrashedNot switches. Use zero or one of these, but not both.'}
            
            # Value-mapped filters
            If ($Filetype)        {$FilterSet += @{'fileType'=@{'eq'= ($Filetype | ForEach {$_ -as [int]})}}}
            If ($FiletypeNot)     {$FilterSet += @{'fileType'=@{'neq'=($FiletypeNot | ForEach {$_ -as [int]})}}}
            If ($FileAccessLevel) {$FilterSet += @{'sharing'= @{'eq'= ($FileAccessLevel | ForEach {$_ -as [int]})}}}
            If ($AppName)         {$FilterSet += @{'service'= @{'eq'= ($AppName | ForEach {$_ -as [int]})}}}  
            If ($AppNameNot)      {$FilterSet += @{'service'= @{'neq'=($AppNameNot | ForEach {$_ -as [int]})}}}  

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
            If ($Folders)              {$FilterSet += @{'folder'=      @{'eq'=$true}}}
            If ($FoldersNot)           {$FilterSet += @{'folder'=      @{'eq'=$false}}}
            If ($Quarantined)          {$FilterSet += @{'quarantined'= @{'eq'=$true}}} 
            If ($QuarantinedNot)       {$FilterSet += @{'quarantined'= @{'eq'=$false}}} 
            If ($Trashed)              {$FilterSet += @{'trashed'=     @{'eq'=$true}}}
            If ($TrashedNot)           {$FilterSet += @{'trashed'=     @{'eq'=$false}}}
           
            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-MCASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try 
            {
                $ListResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -Body $Body -Method Post -Token $Token                    
            }
                Catch 
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $ListResponse
        }
}

<#
.Synopsis
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
.DESCRIPTION
   Send-MCASDiscoveryLog uploads an edge device log file to be analyzed for SaaS discovery by Cloud App Security.

   When using Send-MCASDiscoveryLog, you must provide a log file by name/path and a log file type, which represents the source firewall or proxy device type. Also required is the name of the discovery data source with which the uploaded log should be associated; this can be created in the console.

   Send-MCASDiscoveryLog does not return any value

.EXAMPLE
   Send-MCASDiscoveryLog -LogFile C:\Users\Alice\MyFirewallLog.log -LogType CISCO_IRONPORT_PROXY -DiscoveryDataSource 'My CAS Discovery Data Source'

   This uploads the MyFirewallLog.log file to CAS for discovery, indicating that it is of the CISCO_IRONPORT_PROXY log format, and associates it with the data source name called 'My CAS Discovery Data Source'

.FUNCTIONALITY
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
#>
function Send-MCASDiscoveryLog
{
    [CmdletBinding()]
    [Alias('Send-CASDiscoveryLog')]
    Param
    (
        # The full path of the Log File to be uploaded, such as 'C:\mylogfile.log'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Validatescript({Test-Path $_})]
        [string]$LogFile,
        
        # Specifies the source device type of the log file.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [device_type[]]$LogType,
        
        # Specifies the discovery data source name as reflected in your CAS console, such as 'US West Microsoft ASA'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$DiscoveryDataSource,
        
        # Specifies that the uploaded log file should be deleted after the upload operation completes.
        [alias("dts")]
        [switch]$Delete,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential
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
        # Get just the file name, for when full path is specified
        Try
        {
            $FileName = (Get-Item $LogFile).Name
        }
            Catch
            {
                Throw "Could not get $LogFile : $_"    
            }

        #region GET UPLOAD URL
        Try 
        {       
            # Get an upload URL for the file
            $GetUploadUrlResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/discovery/upload_url/?filename=$FileName&source=$LogType" -Headers @{Authorization = "Token $Token"} -Method Get  

            $UploadUrl = $GetUploadUrlResponse.url           
        }
            Catch 
            { 
                If ($_ -like 'The remote server returned an error: (404) Not Found.') 
                {
                    Throw "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Throw '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Throw "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                Else 
                {
                    Throw "Unknown exception when attempting to contact the Cloud App Security REST API: $_"
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
                    Throw "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Throw '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Throw "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                Else 
                {
                    Throw "File upload failed: $_"
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
                    Throw "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Throw '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Throw "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                ElseIf ($_ -match "The remote server returned an error: (400) Bad Request.")
                {
                    Throw "400 - Bad Request: Ensure the -DiscoveryDataSource parameter specifies a valid data source name that you have created in the CAS web console."
                }
                Else 
                {
                    Throw "Unknown exception when attempting to contact the Cloud App Security REST API: $_"
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
                Throw "Could not delete $LogFile : $_"
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
   Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -MarkAs Read

    This marks a single specified alert as 'Read'. 

.EXAMPLE
   Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -Dismiss

    This will set the status of the specified alert as "Dismissed".

.EXAMPLE
   Get-MCASAlert -Unread -SortBy Date -SortDirection Descending -ResultSetSize 10 | Set-MCASAlert -MarkAs Read

    This will pull the last 10 alerts that were generated with a status of 'Unread' and will mark them all as 'Read'.

.FUNCTIONALITY
   Set-MCASAlert is intended to function as a mechanism for setting the status of alerts Cloud App Security.
#>
function Set-MCASAlert
{
    [CmdletBinding()]
    [Alias('Set-CASAlert')]
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
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential
    )
    Begin
    {
        $Endpoint = 'alerts'

        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
        If ($Dismiss) {$Action = 'dismiss'}
        If ($MarkAs)  {$Action = $MarkAs.ToLower()} # Convert -MarkAs to lower case, as expected by the CAS API

        Try 
            {
                # Set the alert's state by its id
                $SetResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix $Identity/$Action -Method Post -Token $Token
            }
            Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $SetResponse
    }
    End
    {
    }
}

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
        [Parameter(ParameterSetName='List', Mandatory=$true, Position=0)]
        [ValidatePattern('^[A-Fa-f0-9]{24}$')] 
        [ValidateNotNullOrEmpty()]
        [string]$StreamId,

        # Limits the results by time frame in days. Set to 90 days by default. (Options: 7, 30, or 90)
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('7','30','90')]
        [ValidateNotNullOrEmpty()]
        [int]$TimeFrame=90,

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
        [ValidateNotNullOrEmpty()]
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
                $ListResponse = (Invoke-Restmethod -Uri "https://$TenantUri/cas/api/discovery/" -Body $Body -Headers @{Authorization = "Token $Token"} -ErrorAction Stop -Method Get).data            
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
        [int]$AppId
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
            If ($PSCmdlet.ParameterSetName -eq  'List') # Only run remainder of this end block if not in fetch mode
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency
            
            $Body = @{'skip'=0;'limit'=1} # Base request body

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
                $ListResponse = ((Invoke-WebRequest -Uri "https://$TenantUri/api/v1/saasdb/" -Body $Body -Headers @{Authorization = "Token $Token"} -Method Get -ErrorAction Stop) | ConvertFrom-Json).data              
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
    End
    {
    }
}

<#
.Synopsis
    Get-MCASReport retrieves built-in reports from Cloud App Security.
.DESCRIPTION
    Retrieves data based on the built-in reports.
.EXAMPLE
    Get-MCASReport -ReportName 'Browser Use' | select @{N='Browser';E={$_.unique_identifier}}, @{N='User Count';E={$_.record_data.users.count}} | sort -Property 'User Count' -Descending

    Browser                               User Count
    -------                               ----------
    chrome_53.0.2785.143                           4
    chrome_54.0.2840.71                            4
    unknown_                                       4
    microsoft bits_7.8                             3
    microsoft exchange_                            3
    microsoft exchange rpc_                        2
    edge_14.14393                                  2
    ie_11.0                                        2
    microsoft onenote_16.0.7369.5783               1
    apache-httpclient_4.3.5                        1
    ie_9                                           1
    skype for business_16.0.7369.2038              1
    mobile safari_10.0                             1
    microsoft web application companion_           1
    chrome_54.0.2840.87                            1
    microsoft excel_1.26.1007                      1
    microsoft skydrivesync_17.3.6517.0809          1

    This example retrives the Browser Use report, shows the browser name and user count columns, and sorts by user count descending.
#>
function Get-MCASReport
{
    [CmdletBinding()]
    [Alias('Get-CASReport')]
    Param
    (   
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # -User limits the results to items related to the specified user/users, for example 'alice@contoso.com','bob@contoso.com'. 
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Activity by Location','Browser Use','IP Addresses','IP Addresses for Admins','OS Use','Strictly Remote Users','Cloud App Overview','Inactive Accounts','Privileged Users','Salesforce Special Privileged Accounts','User Logon','Data Sharing Overview','File Extensions','Orphan Files','Outbound Sharing by Domain','Owners of Shared Files','Personal User Accounts','Sensitive File Names')]
        [string]$ReportName
    )
    Begin
    {
        $Endpoint = $ReportsList.$ReportName

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

            # Get the matching items and handle errors
            Try 
            {                  
                $ListResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/reports/$Endpoint" -Headers @{Authorization = "Token $Token"}
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
                $ListResponse.data
               
    }
    
}

<#
.Synopsis
    Get-MCASStream retrieves a list of available discovery streams.
.DESCRIPTION
    Discovery streams are used to separate or aggregate discovery data. Stream ID's are needed when pulling discovered app data.
.EXAMPLE
    (Get-MCASStream | ?{$_.displayName -match 'Global'})._id

    57869aceb4b3d5154f095af7

    This example retrives the global stream ID.
#>
function Get-MCASStream
{
    [CmdletBinding()]
    [Alias('Get-CASStream')]
    Param
    (   
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential
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

            # Get the matching items and handle errors
            Try 
            {                  
                $ListResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/discovery/streams/" -Headers @{Authorization = "Token $Token"}
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
                $ListResponse.streams
               
    }
    
}

<#
.Synopsis
    Get-MCASGovernanceLog retrives governance log entries.
.DESCRIPTION
    The MCAS governance log contains entries for when the product performs an action such as parsing log files or quarantining files. This function retrives those entries.
.EXAMPLE
    Get-MCASGovernanceLog -ResultSetSize 10 -Status Successful,Failed -AppName Microsoft_Cloud_App_Security | select taskname, @{N='Status';E={$_.status.isSuccess}}

    taskName                  Status
    --------                  ------
    DiscoveryParseLogTask      False
    DiscoveryAggregationsTask   True
    DiscoveryParseLogTask       True
    DiscoveryParseLogTask      False
    DiscoveryParseLogTask      False
    DiscoveryParseLogTask      False
    DiscoveryParseLogTask      False
    DiscoveryParseLogTask       True
    DiscoveryParseLogTask       True
    DiscoveryParseLogTask       True

      This example retrives the last 10 actions for CAS that were both successful and failed and displays their task name and status.
.FUNCTIONALITY

#>
function Get-MCASGovernanceLog
{
    [CmdletBinding()]
    [Alias('Get-CASGovernanceLog')]
    Param
    (   
        # Fetches an activity object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidatePattern("((\d{8}_\d{5}_[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})|([A-Za-z0-9]{20}))")]
        [alias("_id")]
        [string]$Identity,
        
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Limits the results to items related to the specified service ID's, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int[]]$AppId,

        # Limits the results to items related to the specified app names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$AppName,
        
        # Limits the results to items not related to the specified service ID's, for example 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int[]]$AppIdNot,
        
        # Limits the results to items not related to the specified app names, such as 'Office 365' and 'Google Apps'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [mcas_app[]]$AppNameNot,

        # Limits the results to events listed for the specified File ID.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("UserSettingsLink","ActiveDirectoryAutoImportTask","ActiveDirectoryImportTask","AddRemoveFileToFolder","WritersCanShare","DiscoveryCreateSnapshotStreamTask","DiscoveryDeletionTask","DisableAppTask","EnableAppTask","EncryptFileTask","DiscoveryEntitiesExport","DiscoveryAggregationsTask","GrantReadForDomainPermissionFileTask","GrantUserReadPermissionFileTask","RemoveEveryoneFileTask","NotifyUserOnTokenTask","DeleteFileTask","DiscoveryParseLogTask","AdminQuarantineTask","QuarantineTask","DiscoveryCalculateTask","RescanFileTask","RemoveCollaboratorPermissionFileTask","RemoveSharedLinkFileTask","RemoveExternalFileTask","OnlyOwnersShare","RemovePublicFileTask","RemoveExternalUserCollaborations","Require2StepAuthTask","RevokePasswordUserTask","AdminUnquarantineTask","UnQuarantineTask","BoxCollaboratorsOnly","RevokeSuperadmin","RevokeAccessTokenTask","RevokeUserAccessTokenTask","RevokeUserReadPermissionFileTask","GenerateBoxSharingNotificationsTask","OwnershipNotificationTask","DetonateFileTask","SuspendUserTask","TransferOwnership","TransferOwnershipFileTask","TrashFileTask","UnsuspendUserTask")]
        [string[]]$Action,

        # Limits the results to events listed for the specified IP Tags.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [validateset('Failed','Pending','Successful')]
        [string[]]$Status,

        # Specifies the property by which to sort the results. Possible Values: 'Date','Created'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('timestamp')]
        [string]$SortBy,
                
        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results (up to 10000) to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,10000)]
        [int]$ResultSetSize = 5000,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [int]$Skip = 0
    )
    Begin
    {
        $Endpoint = 'governance'

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
            Try 
            {
                # Fetch the item by its id
                $FetchResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -EndpointSuffix $Identity -Method Post -Token $Token
            }
                Catch
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            $FetchResponse
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
            If ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            If ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {Throw 'Cannot reconcile app parameters. Only use one of them at a time.'}

            # Value-mapped filters
            If ($AppName)    {$FilterSet += @{'appId'=     @{'eq'= ($AppName | ForEach {$_ -as [int]})}}}
            If ($AppNameNot) {$FilterSet += @{'appId'=     @{'neq'=($AppNameNot | ForEach {$_ -as [int]})}}}
            If ($Status)     {$FilterSet += @{'status'=    @{'eq'= ($Status | foreach {$GovernanceStatus.$_})}}}
            If ($Action)     {$FilterSet += @{'type'=      @{'eq'= ($Action | foreach {$_})}}}

            # Simple filters
            If ($AppId)                {$FilterSet += @{'appId'=             @{'eq'=$AppId}}}
            If ($AppIdNot)             {$FilterSet += @{'appId'=             @{'neq'=$AppIdNot}}}

            # Add filter set to request body as the 'filter' property            
            If ($FilterSet) {$Body.Add('filters',(ConvertTo-MCASJsonFilterString $FilterSet))}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try 
            {
                $ListResponse = Invoke-MCASRestMethod -TenantUri $TenantUri -Endpoint $Endpoint -Body $Body -Method Post -Token $Token                    
            }
                Catch 
                { 
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }
            If ($ListResponse.total -eq 0){Write-Verbose 'No governance log entries found for specified filters.'}
            Else {$ListResponse}
            
        }
    }
}

#endregion -----------------------------Cmdlets-----------------------------

#region ------------------------------Export------------------------------

# Vars to export
Export-ModuleMember -Variable CASCredential

# Cmdlets to export
Export-ModuleMember -Function Get-MCASAccount
Export-ModuleMember -Function Get-MCASActivity
Export-ModuleMember -Function Get-MCASAlert
Export-ModuleMember -Function Get-MCASCredential
Export-ModuleMember -Function Get-MCASFile
Export-ModuleMember -Function Send-MCASDiscoveryLog
Export-ModuleMember -Function Set-MCASAlert
Export-ModuleMember -Function Get-MCASDiscoveredApp
Export-ModuleMember -Function Get-MCASAppInfo
Export-ModuleMember -Function Get-MCASReport
Export-ModuleMember -Function Get-MCASStream
Export-ModuleMember -Function Get-MCASGovernanceLog

# Items to only export during dev/testing only
#Export-ModuleMember -Function ConvertTo-MCASJsonFilterString
#Export-ModuleMember -Function Invoke-MCASRestMethod
#Export-ModuleMember -Function Select-MCASTenantUri
#Export-ModuleMember -Function Select-MCASToken

#endregion ------------------------------Export------------------------------