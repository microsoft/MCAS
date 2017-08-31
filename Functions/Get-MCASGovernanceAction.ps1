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
function Get-MCASGovernanceAction
{
    [CmdletBinding()]
    [Alias('Get-CASGovernanceLog','Get-MCASGovernanceLog')]
    Param
    (
        # Fetches an activity object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern('((\d{8}_\d{5}_[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})|([A-Za-z0-9]{20}))')]
        [alias('_id')]
        [string]$Identity,

        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Specifies the property by which to sort the results. Possible Values: 'Date','Created'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('timestamp')]
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

        # Limits the results to events listed for the specified File ID.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("UserSettingsLink","ActiveDirectoryAutoImportTask","ActiveDirectoryImportTask","AddRemoveFileToFolder","WritersCanShare","DiscoveryCreateSnapshotStreamTask","DiscoveryDeletionTask","DisableAppTask","EnableAppTask","EncryptFileTask","DiscoveryEntitiesExport","DiscoveryAggregationsTask","GrantReadForDomainPermissionFileTask","GrantUserReadPermissionFileTask","RemoveEveryoneFileTask","NotifyUserOnTokenTask","DeleteFileTask","DiscoveryParseLogTask","AdminQuarantineTask","QuarantineTask","DiscoveryCalculateTask","RescanFileTask","RemoveCollaboratorPermissionFileTask","RemoveSharedLinkFileTask","RemoveExternalFileTask","OnlyOwnersShare","RemovePublicFileTask","RemoveExternalUserCollaborations","Require2StepAuthTask","RevokePasswordUserTask","AdminUnquarantineTask","UnQuarantineTask","BoxCollaboratorsOnly","RevokeSuperadmin","RevokeAccessTokenTask","RevokeUserAccessTokenTask","RevokeUserReadPermissionFileTask","GenerateBoxSharingNotificationsTask","OwnershipNotificationTask","DetonateFileTask","SuspendUserTask","TransferOwnership","TransferOwnershipFileTask","TrashFileTask","UnsuspendUserTask")]
        [string[]]$Action,

        # Limits the results to events listed for the specified IP Tags.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [validateset('Failed','Pending','Successful')]
        [string[]]$Status
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
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/governance/$Identity/" -Method Get -Token $Token
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
            If ($AppName)    {$FilterSet += @{'appId'=  @{'eq'= ($AppName | ForEach-Object {$_ -as [int]})}}}
            If ($AppNameNot) {$FilterSet += @{'appId'=  @{'neq'=($AppNameNot | ForEach-Object {$_ -as [int]})}}}
            If ($Status)     {$FilterSet += @{'status'= @{'eq'= ($Status | ForEach-Object {$GovernanceStatus.$_})}}}
            If ($Action)     {$FilterSet += @{'type'=   @{'eq'= ($Action | ForEach-Object {$_})}}}

            # Simple filters
            If ($AppId)    {$FilterSet += @{'appId'= @{'eq'=$AppId}}}
            If ($AppIdNot) {$FilterSet += @{'appId'= @{'neq'=$AppIdNot}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try {
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/governance/" -Body $Body -Method Post -Token $Token -FilterSet $FilterSet
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

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
