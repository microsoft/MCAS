<#
.Synopsis
    Get-MCASGovernanceLog retrives governance log entries.
.DESCRIPTION
    The MCAS governance log contains entries for when the product performs an action such as parsing log files or quarantining files. This function retrives those entries.
.EXAMPLE
    PS C:\> Get-MCASGovernanceLog -ResultSetSize 10 -Status Successful,Failed -AppName Microsoft_Cloud_App_Security | select taskname, @{N='Status';E={$_.status.isSuccess}}

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
function Get-MCASGovernanceAction {
    [CmdletBinding()]
    param
    (
        # Fetches an activity object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern('((\d{8}_\d{5}_[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})|([A-Za-z0-9]{20}))')]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias('_id')]
        [string]$Identity,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

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
        [ValidateSet('Failed','Pending','Successful')]
        [string[]]$Status
    )
    begin {}
    process
    {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($PSCmdlet.ParameterSetName -eq 'Fetch')
        {
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/governance/$Identity/" -Method Get
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }
            
            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}
            
            $response
        }
    }
    end
    {
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
                $body.Add('sortField',$SortBy.ToLower())
            }
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $filterSet = @() # Filter set array

            # Additional parameter validations and mutual exclusions
            if ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}

            # Value-mapped filters
            if ($AppName)    {$filterSet += @{'appId'=  @{'eq'= ([int[]]($AppName | ForEach-Object {$_ -as [int]}))}}}
            if ($AppNameNot) {$filterSet += @{'appId'=  @{'neq'=([int[]]($AppNameNot | ForEach-Object {$_ -as [int]}))}}}       
            if ($Status)     {$filterSet += @{'status'= @{'eq'= ($Status | ForEach-Object {$GovernanceStatus.$_})}}}
            if ($Action)     {$filterSet += @{'type'=   @{'eq'= ($Action | ForEach-Object {$_})}}}

            # Simple filters
            if ($AppId)    {$filterSet += @{'appId'= @{'eq'=$AppId}}}
            if ($AppIdNot) {$filterSet += @{'appId'= @{'neq'=$AppIdNot}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/governance/" -Body $body -Method Post -FilterSet $filterSet
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }

            $response = $response.data 
            
            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}

            $response
        }
    }
}