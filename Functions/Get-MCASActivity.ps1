<#
.Synopsis
   Gets user activity information from your Cloud App Security tenant.
.DESCRIPTION
   Gets user activity information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASActivity gets 100 activity records and associated properties. You can specify a particular activity GUID to fetch a single activity's information or you can pull a list of activities based on the provided filters.

   Get-MCASActivity returns a single custom PS Object or multiple PS Objects with all of the activity properties. Methods available are only those available to custom objects by default.
.EXAMPLE
    PS C:\> Get-MCASActivity -ResultSetSize 1

    This pulls back a single activity record and is part of the 'List' parameter set.

.EXAMPLE
    PS C:\> Get-MCASActivity -Identity 572caf4588011e452ec18ef0

    This pulls back a single activity record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
    PS C:\> (Get-MCASActivity -AppName Box).rawJson | ?{$_.event_type -match "upload"} | select ip_address -Unique

    ip_address
    ----------
    69.4.151.176
    98.29.2.44

    This grabs the last 100 Box activities, searches for an event type called "upload" in the rawJson table, and returns a list of unique IP addresses.

.FUNCTIONALITY
   Get-MCASActivity is intended to function as a query mechanism for obtaining activity information from Cloud App Security.
#>
function Get-MCASActivity {
    [CmdletBinding()]
    param
    (
        # Fetches an activity object by its unique identifier.
        [Parameter(ParameterSetName = 'Fetch', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern("[A-Fa-f0-9_\-]{51}|[A-Za-z0-9_\-]{20}")]
        [alias("_id")]
        [string]$Identity,

        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the property by which to sort the results. Possible Values: 'Date','Created'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateSet('Date', 'Created')]
        [string]$SortBy,

        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateSet('Ascending', 'Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateRange(1, 100000)]
        [int]$ResultSetSize,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateScript( { $_ -gt -1 })]
        [int]$Skip = 0,

        # Periodically writes the activities returned in JSON format to a specified file. Useful for large queries. (Example: -PeriodicWriteToFile "C:\path\to\file.txt")
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [string]$PeriodicWriteToFile,



        ##### FILTER PARAMS #####

        # -User limits the results to items related to the specified user/users, for example 'alice@contoso.com','bob@contoso.com'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("User")]
        [string[]]$UserName,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("Service", "Services")]
        [int[]]$AppId,

        # Limits the results to items related to the specified service names, such as 'Office_365' and 'Google_Apps'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("ServiceName", "ServiceNames")]
        [mcas_app[]]$AppName,

        # Limits the results to items not related to the specified service ids, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("ServiceNot", "ServicesNot")]
        [int[]]$AppIdNot,

        # Limits the results to items not related to the specified service names, such as 'Office_365' and 'Google_Apps'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("ServiceNameNot", "ServiceNamesNot")]
        [mcas_app[]]$AppNameNot,

        # Limits the results to items from a particular data source. (Possible Values: 0 = Access control, 1 = Session control, 2 = App connector, 3 = App connector analysis, 5 = Discovery, 6 = MDATP)
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\b[0-6]\b")]
        [int]$Source,

        # Limits the results to items of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$EventTypeName,

        # Limits the results to items not of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$EventTypeNameNot,

        # Limits the results to items of specified action type name, such as '11161:EVENT_AAD_LOGIN:OAuth2:Authorize'
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ActionTypeName,

        # Limits the results to items not of specified action type name, such as '11161:EVENT_AAD_LOGIN:OAuth2:Authorize'
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ActionTypeNameNot,

        # Limits the results by ip category. Possible Values: 'None','Internal','Administrative','Risky','VPN','Cloud_Provider'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ip_category[]]$IpCategory,

        # Limits the results to items with the specified IP leading digits, such as 10.0.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateLength(1, 45)]
        [string[]]$IpStartsWith,

        # Limits the results to items without the specified IP leading digits, such as 10.0.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateLength(1, 45)]
        [string[]]$IpDoesNotStartWith,

        # Limits the results to items found before specified date. Use Get-Date.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateBefore = (Get-Date),

        # Limits the results to items found after specified date. Use Get-Date.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateAfter,

        # Limits the results by device type. Possible Values: 'Desktop','Mobile','Tablet','Other'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateSet('Desktop', 'Mobile', 'Tablet', 'Other')]
        [string[]]$DeviceTypeNot,

        # Limits the results by device type. Possible Values: 'Desktop','Mobile','Tablet','Other'.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateSet('Desktop', 'Mobile', 'Tablet', 'Other')]
        [string[]]$DeviceType,

        # Limits the results by performing a free text search
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_.Length -ge 5 })]
        [string]$Text,

        # Limits the results to events listed for the specified File ID.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern("\b[A-Za-z0-9]{24}\b")]
        [string]$FileID,

        # Limits the results to events listed for the specified AIP classification labels. Use ^ when denoting (external) labels. Example: @("^Private")
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [array]$FileLabel,

        # Limits the results to events excluded by the specified AIP classification labels. Use ^ when denoting (external) labels. Example: @("^Private")
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [array]$FileLabelNot,

        # Limits the results to events listed for the specified IP Tags.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [validateset('Akamai_Technologies', 'Amazon_Web_Services', 'Anonymous_proxy', 'Ascenty_Data_Centers', 'Botnet', 'Brute_force_attacker', 'Cisco_CWS', 'Cloud_App_Security_network', 'Darknet_scanning_IP', 'Exchange_Online', 'Exchange_Online_Protection', 'Google_Cloud_Platform', 'Internal_Network_IP', 'Malware_CnC_server', 'Masergy_Communications', 'McAfee_Web_Gateway', 'Microsoft_Azure', 'Microsoft_Cloud', 'Microsoft_Hosting', 'Microsoft_authentication_and_identity', 'Office_365', 'Office_365_Planner', 'Office_365_ProPlus', 'Office_Online', 'Office_Sway', 'Office_Web_Access_Companion', 'OneNote', 'Remote_Connectivity_Analyzer', 'Salesforce_Cloud', 'Satellite_provider', 'ScanSafe', 'SharePoint_Online', 'Skype_for_Business_Online', 'Symantec_Cloud', 'Tor', 'Yammer', 'Zscaler')]
        [string[]]$IPTag,

        # Limits the results to events listed for the specified IP Tags.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [validateset('Akamai_Technologies', 'Amazon_Web_Services', 'Anonymous_proxy', 'Ascenty_Data_Centers', 'Botnet', 'Brute_force_attacker', 'Cisco_CWS', 'Cloud_App_Security_network', 'Darknet_scanning_IP', 'Exchange_Online', 'Exchange_Online_Protection', 'Google_Cloud_Platform', 'Internal_Network_IP', 'Malware_CnC_server', 'Masergy_Communications', 'McAfee_Web_Gateway', 'Microsoft_Azure', 'Microsoft_Cloud', 'Microsoft_Hosting', 'Microsoft_authentication_and_identity', 'Office_365', 'Office_365_Planner', 'Office_365_ProPlus', 'Office_Online', 'Office_Sway', 'Office_Web_Access_Companion', 'OneNote', 'Remote_Connectivity_Analyzer', 'Salesforce_Cloud', 'Satellite_provider', 'ScanSafe', 'SharePoint_Online', 'Skype_for_Business_Online', 'Symantec_Cloud', 'Tor', 'Yammer', 'Zscaler')]
        [string[]]$IPTagNot,

        # Limits the results to events that include a country code value.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$CountryCodePresent,

        # Limits the results to events that include a country code value.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$CountryCodeNotPresent,

        # Limits the results to events that include a country code value.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(2, 2)]
        [string[]]$CountryCode,

        # Limits the results to events that include a country code value.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(2, 2)]
        [string[]]$CountryCodeNot,

        # Limits the results to events listed for the specified IP Tags.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern("[A-Fa-f0-9]{24}")]
        [string]$PolicyId,

        # Limits the results to items occuring in the last x number of days.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateRange(1, 180)]
        [int]$DaysAgo,

        # Limits the results to admin events if specified.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$AdminEvents,

        # Limits the results to non-admin events if specified.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$NonAdminEvents,

        # Limits the results to impersonated events if specified.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$Impersonated,

        # Limits the results to non-impersonated events if specified.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [switch]$ImpersonatedNot,

        # Limits the results to those with user agent strings containing the specified substring.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$UserAgentContains,

        # Limits the results to those with user agent strings not containing the specified substring.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$UserAgentNotContains,

        # Limits the results to those with user agent tags equal to the specified value(s).
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [validateset('Native_client', 'Outdated_browser', 'Outdated_operating_system', 'Robot')]
        [string[]]$UserAgentTag,

        # Limits the results to those with user agent tags not equal to the specified value(s).
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [validateset('Native_client', 'Outdated_browser', 'Outdated_operating_system', 'Robot')]
        [string[]]$UserAgentTagNot,

        # Limits the results to activities performed by users part of the specified groups.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserGroup,    

        # Limits the results to activities performed by users not part of the specified groups.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserGroupNot,

        # Limits the results to activities performed by users who are part of any imported group.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [switch]$UserGroupPresent, 

        # Limits the results to activities performed by users who are not part of any imported group.
        [Parameter(ParameterSetName = 'List', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [switch]$UserGroupNotPresent
    )
    begin {
        if ($ResultSetSize -gt 100) {
            $ResultSetSizeSecondaryChunks = $ResultSetSize % 100
        }

        if ($PeriodicWriteToFile -and $ResultSetSize -le 100) { throw 'Error: You cannot use periodic file writing with a resultsetsize <= 100. Either remove periodicwritetofile or set your resultsetsize greater than 100.' }
        #if ($Skip -and $ResultSetSize -gt 100){throw 'Error: You cannot use the skip parameter when specifying more than 100 records. Large pull requests will skip for you automatically. Either remove the skip parameter or reduce your resultsetsize to 100 or less.'}
        if (($Skip + $ResultSetSize -gt 5000) -and $Skip -gt 0) { throw 'Error: You cannot pull more than 5000 records when using the -Skip parameter. Either remove -Skip or reduce your -ResultSetSize such that -Skip + -ResultSetSize is less than 5000.' }
        if ($ResultSetSize -gt 5000 -and $ResultSetSize % 100 -ne 0) { throw 'Error: When pulling more than 5000 records, you must keep ResultSetSize as a multiple of 100' }
    }
    process {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($PSCmdlet.ParameterSetName -eq 'Fetch') {
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/$Identity/" -Method Get
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }

            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
                #Fix collisions
                $response = $response.Replace('"Level":', '"Level_2":')
                $response = $response.Replace('"EventName":', '"EventName_2":')
            }
            catch { }


            # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
            try {
                Write-Verbose "Checking for property collision. Converting response to PSObject"
                #$response = $response | ConvertFrom-Json #this may not work anymore.
                #$response = $response.Replace('"Level":', '"Level_2":')
                #$response = $response.Replace('"EventName":', '"EventName_2":')
            }
            catch {
                Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                $response = $response.Replace('"Level":', '"Level_2":')
                $response = $response.Replace('"EventName":', '"EventName_2":')
                try {
                    $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                }
                catch {
                    throw $_
                }
                Write-Verbose "Any property name collisions appear to have been resolved."
            }



            $response
        }
    }
    end {
        if ($PSCmdlet.ParameterSetName -eq 'List') { # Only run remainder of this end block if not in fetch mode
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            $body = @{'skip' = $Skip; 'limit' = $ResultSetSize } # Base request body

            #region ----------------------------SORTING----------------------------

            if ($SortBy -xor $SortDirection) { throw 'Error: When specifying either the -SortBy or the -SortDirection parameters, you must specify both parameters.' }

            # Add sort direction to request body, if specified
            if ($SortDirection) { $Body.Add('sortDirection', $SortDirection.TrimEnd('ending').ToLower()) }

            # Add sort field to request body, if specified
            if ($SortBy) {
                $body.Add('sortField', $SortBy.ToLower())
            }
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $filterSet = @() # Filter set array

            # Additional function for date conversion to unix format.
            if ($DateBefore) { $DateBefore2 = ([int64]((Get-Date -Date $DateBefore) - (get-date "1/1/1970")).TotalMilliseconds) }
            if ($DateAfter) { $DateAfter2 = ([int64]((Get-Date -Date $DateAfter) - (get-date "1/1/1970")).TotalMilliseconds) }
            
            #Set blank
            #$filterSet += @{'date' = @{}}

            # Additional parameter validations and mutual exclusions
            if ($AppName -and ($AppId -or $AppNameNot -or $AppIdNot)) { throw 'Cannot reconcile app parameters. Only use one of them at a time.' }
            if ($AppId -and ($AppName -or $AppNameNot -or $AppIdNot)) { throw 'Cannot reconcile app parameters. Only use one of them at a time.' }
            if ($AppNameNot -and ($AppId -or $AppName -or $AppIdNot)) { throw 'Cannot reconcile app parameters. Only use one of them at a time.' }
            if ($AppIdNot -and ($AppId -or $AppNameNot -or $AppName)) { throw 'Cannot reconcile app parameters. Only use one of them at a time.' }
            #if (($DateBefore -and $DaysAgo) -or ($DateAfter -and $DaysAgo)){throw 'Cannot reconcile app parameters. Only use one date parameter.'}
            if ($Impersonated -and $ImpersonatedNot) { throw 'Cannot reconcile app parameters. Do not combine Impersonated and ImpersonatedNot parameters.' }

            # Value-mapped filters
            if ($IpCategory) { $filterSet += @{'ip.category' = @{'eq' = ([int[]]($IpCategory | ForEach-Object { $_ -as [int] })) } }
            }
            if ($AppName) { $filterSet += @{'service' = @{'eq' = ([int[]]($AppName | ForEach-Object { $_ -as [int] })) } }
            }
            if ($AppNameNot) { $filterSet += @{'service' = @{'neq' = ([int[]]($AppNameNot | ForEach-Object { $_ -as [int] })) } }
            }
            if ($IPTag) { $filterSet += @{'ip.tags' = @{'eq' = ($IPTag.GetEnumerator() | ForEach-Object { $IPTagsList.$_ -join ',' }) } }
            }
            if ($IPTagNot) { $filterSet += @{'ip.tags' = @{'neq' = ($IPTagNot.GetEnumerator() | ForEach-Object { $IPTagsList.$_ -join ',' }) } }
            }
            if ($UserAgentTag) { $filterSet += @{'userAgent.tags' = @{'eq' = ($UserAgentTag.GetEnumerator() | ForEach-Object { $UserAgentTagsList.$_ -join ',' }) } }
            }
            if ($UserAgentTagNot) { $filterSet += @{'userAgent.tags' = @{'neq' = ($UserAgentTagNot.GetEnumerator() | ForEach-Object { $UserAgentTagsList.$_ -join ',' }) } }
            }

            # Simple filters
            if ($UserName) { $filterSet += @{'user.username' = @{'eq' = $UserName } }
            }

    # AppId
            if ($AppId -or $AppIdNot){ 
                $filterSet += @{'service' = @{} 
                }
                $FilterName = "service"
            }
            # AppId
            if ($AppId) { $filterSet.($FilterName).add('eq', $AppId ) }
            # AppIdNot
            if ($AppIdNot) { $filterSet.($FilterName).add('neq', $AppIdNot ) }

    
    # Source
            if ($Source){ 
                $filterSet += @{'source' = @{} 
                }
                $FilterName = "source"
            }
            # EventTypeName
            if ($Source) { $filterSet.($FilterName).add('eq', $Source ) }


    # EventTypeName / EventTypeNameNot
            if ($EventTypeName -or $EventTypeNameNot){ 
                $filterSet += @{'activity.eventType' = @{} 
                }
                $FilterName = "activity.eventType"
            }
            # EventTypeName
            if ($EventTypeName) { $filterSet.($FilterName).add('eq', $EventTypeName ) }
            # EventTypeNameNot
            if ($EventTypeNameNot) { $filterSet.($FilterName).add('neq', $EventTypeNameNot ) }


    # ActionTypeName / ActionTypeNameNot
            if ($ActionTypeName -or $ActionTypeNameNot){ 
                $filterSet += @{'activity.actionType' = @{} 
                }
                $FilterName = "activity.actionType"
            }
            # ActionTypeName
            if ($ActionTypeName) { $filterSet.($FilterName).add('eq', $ActionTypeName ) }
            # ActionTypeNameNot
            if ($ActionTypeNameNot) { $filterSet.($FilterName).add('neq', $ActionTypeNameNot ) }

    
    # UserGroup / UserGroupNot / UserGroupPresent / UserGroupNotPresent
            if ($UserGroup -or $UserGroupNot -or $UserGroupNotPresent -or $UserGroupPresent){ 
                $filterSet += @{'user.tags' = @{} 
                }
                $FilterName = "user.tags"
            }
            # UserGroup
            if ($UserGroup) { 

                $UserGroupArray = @(
                    @{
                        role = 1
                        adv = $true
                    }
                    $UserGroup
                )

                $filterSet.($FilterName).add('eq', $UserGroupArray) 
            } 
            # UserGroupNot
            if ($UserGroupNot) { 

                $UserGroupNotArray = @(
                    @{
                        role = 1
                        adv = $true
                    }
                    $UserGroupNot
                )

                $filterSet.($FilterName).add('neq', $UserGroupNotArray) 
            } 
            # UserGroupPresent
            if ($UserGroupPresent) { $filterSet.($FilterName).add('isset', $true)}
            # UserGroupNotPresent
            if ($UserGroupNotPresent) { $filterSet.($FilterName).add('isnotset', $true)}
            


    # CountryCode / CountryCodeNot / CountryCodePresent / CountryCodeNotPresent
            if ($CountryCode -or $CountryCodeNot){ 
                $filterSet += @{'location.country' = @{} 
                }
                $FilterName = "location.country"
            }
            # CountryCode
            if ($CountryCode) { $filterSet.($FilterName).add('eq', $CountryCode ) }
            # CountryCodeNot
            if ($CountryCodeNot) { $filterSet.($FilterName).add('neq' , $CountryCodeNot ) }
            # CountryCodePresent
            if ($CountryCodePresent) { $filterSet.($FilterName).add('isset' , $true ) }
            # CountryCodeNotPresent
            if ($CountryCodeNotPresent) { $filterSet.($FilterName).add('isnotset' , $true ) }


    # DeviceType / DeviceTypeNot
            if ($DeviceType -or $DeviceTypeNot){ 
                $filterSet += @{'device.type' = @{} 
                }
                $FilterName = "device.type"
            }
            #DeviceType
            if ($DeviceType) { $filterSet.($FilterName).add('eq', $DeviceType.ToUpper() ) }
            #DeviceTypeNot
            if ($DeviceTypeNot) { $filterSet.($FilterName).add('neq', $DeviceTypeNot.ToUpper() ) }
            

    # UserAgentContains / UserAgentNotContains
            if ($UserAgentContains -or $UserAgentNotContains){ 
                $filterSet += @{'userAgent.userAgent' = @{} 
                }
                $FilterName = "userAgent.userAgent"
            }
            # UserAgentContains
            if ($UserAgentContains) { $filterSet.($FilterName).add('contains', $UserAgentContains ) }
            # UserAgentNotContains
            if ($UserAgentNotContains) { $filterSet.($FilterName).add('ncontains', $UserAgentNotContains) }


    # IpStartsWith / $IpDoesNotStartWith
            if ($IpStartsWith -or $IpDoesNotStartWith){ 
                $filterSet += @{'ip.address' = @{} 
                }
                $FilterName = "ip.address"
            }
            #IpStartsWith
            if ($IpStartsWith) { $filterSet.($FilterName).add('startswith', $IpStartsWith ) }
            #IpDoesNotStartWith
            if ($IpDoesNotStartWith) { $filterSet.($FilterName).add('doesnotstartwith', $IpDoesNotStartWith) }


    # Text
            if ($Text){ 
                $filterSet += @{'text' = @{} 
                }
                $FilterName = "text"
            }
            # Text
            if ($Text) { $filterSet.($FilterName).add('text', $Text ) }


    # Impersonated / ImpersonatedNot
            if ($Impersonated -or $ImpersonatedNot){ 
                $filterSet += @{'activity.impersonated' = @{} 
                }
                $FilterName = "activity.impersonated"
            }
            #DeviceType
            if ($Impersonated) { $filterSet.($FilterName).add('eq', $true ) }
            #DeviceTypeNot
            if ($ImpersonatedNot) { $filterSet.($FilterName).add('eq', $false ) }

    
    # FileId 
            if ($FileID){ 
                $filterSet += @{'fileSelector' = @{} 
                }
                $FilterName = "fileSelector"
            }
            # FileId
            if ($FileID) { $filterSet.($FilterName).add('eq', $FileID ) }
      

    # FileLabel 
            if ($FileLabel){ 
                $filterSet += @{'fileLabels' = @{} 
                }
                $FilterName = "fileLabels"
            }
            # FileLabel
            if ($FileLabel) { $filterSet.($FilterName).add('eq', $FileLabel ) }


    # PolicyId
            if ($PolicyId){ 
                $filterSet += @{'policy' = @{} 
                }
                $FilterName = "policy"
            }
            # PolicyId
            if ($PolicyId) { $filterSet.($FilterName).add('eq', $PolicyId ) }


    # AdminEvents / NonAdminEvents
            if ($AdminEvents -or $NonAdminEvents){ 
                $filterSet += @{'activity.type' = @{} 
                }
                $FilterName = "activity.type"
            }
            # AdminEvents
            if ($AdminEvents) { $filterSet.($FilterName).add('eq', $true ) }
            # NonAdminEvents
            if ($NonAdminEvents) { $filterSet.($FilterName).add('eq', $false ) }            


    # DaysAgo / DateBefore / DateAfter
            if ($DaysAgo) { $filterSet += @{'date' = @{'gte_ndays' = $DaysAgo } }
            }
            if ($DateBefore -and (-not $DateAfter)) { $filterSet += @{'date' = @{'lte' = $DateBefore2 } }
            }
            if ($DateAfter -and (-not $DateBefore)) { $filterSet += @{'date' = @{'gte' = $DateAfter2 } }
            }
            if ($DateAfter -and $DateBefore) {
                $filterSet += @{'date' = @{'range' = @(
                            @{
                                'start' = $DateAfter2
                                'end'   = $DateBefore2
                            }
                        )
                    }
                }
            }

            if ($DaysAgo -and $DateBefore) {
                $filterSet += @{'date' = 
                    @{
                        'gte_ndays' = $DaysAgo
                        'lte'       = $DateBefore2
                    }
                }
            }

            #endregion ----------------------------FILTERING----------------------------
        }

        $collection = @()
        $i = $Skip
        $latestTimestamp = $DateBefore2

        #if no resultsetsize is specified - get all matching records up to 5000 using skip/limit method and stopping when all matches are returned. This uses hasnext

        if (!$ResultSetSize -and $PSCmdlet.ParameterSetName -ne 'Fetch') {
            Write-Verbose "Running loop A."

            #This first call gets us the total number of matches.
            $response = (Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw) 

            try {
                $response = $response | ConvertFrom-Json
            }
            catch {
                Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                $response = $response.Replace('"Level":', '"Level_2":')
                $response = $response.Replace('"EventName":', '"EventName_2":')
                try {
                    $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                }
                catch {
                    throw $_
                }
                Write-Verbose "Any property name collisions appear to have been resolved."
            }
            $responsetotal = $response.total
            Write-Verbose "Total Matching Records: $responsetotal"

            $ResultSetSizeSecondaryChunks = $responsetotal % 100
            $ResponseTotalMultiple100 = $responsetotal - $ResultSetSizeSecondaryChunks

            $hasnext = $response.hasnext
            Write-Verbose "HasNext: $hasnext"

            $collection = @()
            $i = $Skip
            $latestTimestamp = $DateBefore2
            $returnedrecords = 100 #we set this to a default of 100 but it can be overwritten during subsequent calls to match what the tenant is set for.

            do {
                $body = @{'skip' = $i; 'limit' = $returnedrecords } # Base request body

                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw
                }
                catch {
                    throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

                $response = $response.Content

                # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
                try {
                    $response = $response | ConvertFrom-Json
                }
                catch {
                    Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                    $response = $response.Replace('"Level":', '"Level_2":')
                    $response = $response.Replace('"EventName":', '"EventName_2":')
                    try {
                        $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                    }
                    catch {
                        throw $_
                    }
                    Write-Verbose "Any property name collisions appear to have been resolved."
                }
                $hasnext = $response.hasnext
                $response = $response.data

                try {
                    Write-Verbose "Adding alias property to results, if appropriate"
                    $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
                }
                catch { }

                $collection += $response
                if ($PeriodicWriteToFile) {
                    Write-Verbose "Writing response output to $PeriodicWriteToFile"
                    $collection | ConvertTo-Json -depth 10 | Out-File $PeriodicWriteToFile
                }
                $returnedrecords = ($response | Measure-Object).count
                $i += $returnedrecords
                

            }
            while ($hasnext -eq $true)


            $collection
        }

    



        #if a resultsetsize > 5000 is specified, use the timestamp method

        if ($ResultSetSize -gt 5000 -and $skip -eq 0){
            Write-Verbose "Running loop B. This uses timestamps."
            do{
                $body = @{'skip'=0;'limit'=100} # Base request body
                $filterSet = @{'date'= @{'lte'=$latestTimestamp}}


                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw
                }
                catch {
                    throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

                $response = $response.Content

                # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
                try {
                    $response = $response | ConvertFrom-Json
                }
                catch {
                    Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                    $response = $response.Replace('"Level":','"Level_2":')
                    $response = $response.Replace('"EventName":','"EventName_2":')
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

                $collection += $response
                if ($PeriodicWriteToFile){
                    Write-Verbose "Writing response output to $PeriodicWriteToFile"
                    $collection | ConvertTo-Json -depth 10 | Out-File $PeriodicWriteToFile
                }
                $i+= 100
                $latestTimestamp = ($response | Select-Object -Last 1).timestamp
                Write-Verbose "$i records pulled so far."
                }
            while($i -lt $ResultSetSize - $ResultSetSizeSecondaryChunks)

            if ($ResultSetSizeSecondaryChunks -gt 0){
                Write-Verbose "Running loop D."
                $body = @{'skip'=($ResultSetSize - $ResultSetSizeSecondaryChunks);'limit'=$ResultSetSizeSecondaryChunks}

               try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw
                }
                catch {
                    throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

                $response = $response.Content

                # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
                try {
                    $response = $response | ConvertFrom-Json
                }
                catch {
                    Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                    $response = $response.Replace('"Level":','"Level_2":')
                    $response = $response.Replace('"EventName":','"EventName_2":')
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

                $collection += $response
                if ($PeriodicWriteToFile){
                    Write-Verbose "Writing response output to $PeriodicWriteToFile"
                    $collection | ConvertTo-Json -depth 10 | Out-File $PeriodicWriteToFile
                }

                }


                $collection
            }







        #if a resultsetsize <= 5000 and > 100 is specified, perform a simple call using skip/limit

        if ($ResultSetSize -le 5000 -and $ResultSetSize -gt 100) {
            Write-Verbose "Running loop C. This uses skip/limit."


            do {
                $body = @{'skip' = $i; 'limit' = 100 } # Base request body

                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw
                }
                catch {
                    throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

                $response = $response.Content

                # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
                try {
                    $response = $response | ConvertFrom-Json
                }
                catch {
                    Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                    $response = $response.Replace('"Level":', '"Level_2":')
                    $response = $response.Replace('"EventName":', '"EventName_2":')
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
                catch { }

                $collection += $response
                if ($PeriodicWriteToFile) {
                    Write-Verbose "Writing response output to $PeriodicWriteToFile"
                    $collection | ConvertTo-Json -depth 10 | Out-File $PeriodicWriteToFile
                }
                $i += 100

            }
            while ($i -lt $ResultSetSize + $skip - $ResultSetSizeSecondaryChunks)

            if ($ResultSetSizeSecondaryChunks -gt 0) {
                Write-Verbose "Running loop D. This uses skip/limit"
                $body = @{'skip' = ($ResultSetSize - $ResultSetSizeSecondaryChunks); 'limit' = $ResultSetSizeSecondaryChunks }

                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw
                }
                catch {
                    throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

                $response = $response.Content

                # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
                try {
                    $response = $response | ConvertFrom-Json
                }
                catch {
                    Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                    $response = $response.Replace('"Level":', '"Level_2":')
                    $response = $response.Replace('"EventName":', '"EventName_2":')
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
                catch { }

                $collection += $response
                if ($PeriodicWriteToFile) {
                    Write-Verbose "Writing response output to $PeriodicWriteToFile"
                    $collection | ConvertTo-Json -depth 10 | Out-File $PeriodicWriteToFile
                }

            }

            $collection
        }

       





        # if resultsetsize <= 100 specified, perform single call using skip/limit method
        if ($ResultSetSize -le 100 -and $ResultSetSize -ne 0) {
            Write-Verbose "Running loop E. This will make a single call."
            # Get the matching items and handle errors
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/activities/" -Body $body -Method Post -FilterSet $filterSet -Raw
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }

            $response = $response.Content
            

            # Attempt the JSON conversion. If it fails due to property name collisions to to case insensitivity on Windows, attempt to resolve it by renaming the properties.
            try {
                $response = $response | ConvertFrom-Json
            }
            catch {
                Write-Verbose "One or more property name collisions were detected in the response. An attempt will be made to resolve this by renaming any offending properties."
                $response = $response.Replace('"Level":', '"Level_2":')
                $response = $response.Replace('"EventName":', '"EventName_2":')
                try {
                    $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                }
                catch {
                    throw $_
                }
                Write-Verbose "Any property name collisions appear to have been resolved."
            }
            $recordtotal = $response.total
            
            $response = $response.data


            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch { }
            $response
        }
    }
}