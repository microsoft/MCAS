<#
.Synopsis
   Gets file information from your Cloud App Security tenant.
.DESCRIPTION
   Gets file information from your Cloud App Security tenant and requires a credential be provided.

   Without parameters, Get-MCASFile gets 100 file records and associated properties. You can specify a particular file GUID to fetch a single file's information or you can pull a list of activities based on the provided filters.

   Get-MCASFile returns a single custom PS Object or multiple PS Objects with all of the file properties. Methods available are only those available to custom objects by default.
.EXAMPLE
    PS C:\> Get-MCASFile -ResultSetSize 1

    This pulls back a single file record and is part of the 'List' parameter set.

.EXAMPLE
    PS C:\> Get-MCASFile -Identity 572caf4588011e452ec18ef0

    This pulls back a single file record using the GUID and is part of the 'Fetch' parameter set.

.EXAMPLE
    PS C:\> Get-MCASFile -AppName Box -Extension pdf -Domains 'microsoft.com' | select name

    name                      dlpScanTime
    ----                      -----------
    pdf_creditcardnumbers.pdf 2016-06-08T19:00:36.534000Z
    mytestdoc.pdf             2016-06-12T22:00:45.235000Z
    powershellrules.pdf       2016-06-03T13:00:19.776000Z

    This searches Box files for any PDF documents owned by any user in the microsoft.com domain and returns the names of those documents and the last time they were scanned for DLP violations.

.FUNCTIONALITY
   Get-MCASFile is intended to function as a query mechanism for obtaining file information from Cloud App Security.
#>
function Get-MCASFile {
    [CmdletBinding()]
    param
    (
        # Fetches a file object by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [alias("_id")]
        [string]$Identity,

        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the property by which to sort the results. Possible Value: 'DateModified'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('DateModified')]
        [string]$SortBy,

        # Specifies the direction in which to sort the results. Possible Values: 'Ascending','Descending'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateSet('Ascending','Descending')]
        [string]$SortDirection,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100000)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0,

        # Periodically writes the activities returned in JSON format to a specified file. Useful for large queries. (Example: -PeriodicWriteToFile "C:\path\to\file.txt")
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [string]$PeriodicWriteToFile,


        ##### FILTER PARAMS #####

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

        # Limits the results to files listed for the specified AIP classification labels. Use ^ when denoting (external) labels. Example: @("^Private")
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [array]$FileLabel,

        # Limits the results to files excluded by the specified AIP classification labels. Use ^ when denoting (external) labels. Example: @("^Private")
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [array]$FileLabelNot,

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

        # Limits the results to items with the specified policy ids, such as '59c1954dbff351a11ae56fe2', '59a8657ebff351ba49d5955f'.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$PolicyId,

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
        [switch]$FoldersNot
    )
    begin {
        if ($ResultSetSize -gt 100){
            $ResultSetSizeSecondaryChunks = $ResultSetSize % 100
        }

    }
    process
    {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($PSCmdlet.ParameterSetName -eq 'Fetch')
        {
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/files/$Identity/" -Method Get -Raw
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
                $response = $response.Replace('"Created":','"Created_2":')
                $response = $response.Replace('"ftags":','"ftags_2":')
                try {
                    $response = $response | ConvertFrom-Json # Try the JSON conversion again, now that we hopefully fixed the property collisions
                }
                catch {
                    throw $_
                }
                Write-Verbose "Any property name collisions appear to have been resolved."
            }

            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
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
            if ($SortBy -eq 'DateModified') {$body.Add('sortField','modifiedDate')}

            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $filterSet = @() # Filter set array

            # Additional Hash Tables for Filetype & FiletypeNot Filters
            if ($Filetype) {
                $filetypehashtable = @{}
                $Filetype | ForEach-Object {$filetypehashtable.Add($_,$_)}
                }
            if ($FiletypeNot) {
                $filetypehashtable = @{}
                $FiletypeNot | ForEach-Object {$filetypehashtable.Add($_,$_)}
                }

            # Additional parameter validations and mutual exclusions
            if ($AppName    -and ($AppId   -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppId      -and ($AppName -or $AppNameNot -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppNameNot -and ($AppId   -or $AppName    -or $AppIdNot)) {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($AppIdNot   -and ($AppId   -or $AppNameNot -or $AppName))  {throw 'Cannot reconcile app parameters. Only use one of them at a time.'}
            if ($Folders -and $FoldersNot) {throw 'Cannot reconcile -Folder and -FolderNot switches. Use zero or one of these, but not both.'}
            if ($Quarantined -and $QuarantinedNot) {throw 'Cannot reconcile -Quarantined and -QuarantinedNot switches. Use zero or one of these, but not both.'}
            if ($Trashed -and $TrashedNot) {throw 'Cannot reconcile -Trashed and -TrashedNot switches. Use zero or one of these, but not both.'}

            # Value-mapped filters
            if ($Filetype)        {$filterSet += @{'fileType'=@{'eq'= ([int[]]($Filetype | ForEach-Object {$_ -as [int]}))}}}
            if ($FiletypeNot)     {$filterSet += @{'fileType'=@{'neq'=([int[]]($FiletypeNot | ForEach-Object {$_ -as [int]}))}}}
            if ($FileAccessLevel) {$filterSet += @{'sharing'= @{'eq'= ([int[]]($FileAccessLevel | ForEach-Object {$_ -as [int]}))}}}
            if ($AppName)         {$filterSet += @{'service'=@{'eq'=([int[]]($AppName | ForEach-Object {$_ -as [int]}))}}}
            if ($AppNameNot)      {$filterSet += @{'service'=@{'neq'=([int[]]($AppNameNot | ForEach-Object {$_ -as [int]}))}}}

            # Simple filters
            if ($AppId)                {$filterSet += @{'service'=                  @{'eq'=$AppId}}}
            if ($AppIdNot)             {$filterSet += @{'service'=                  @{'neq'=$AppIdNot}}}
            if ($Extension)            {$filterSet += @{'extension'=                @{'eq'=$Extension}}}
            if ($ExtensionNot)         {$filterSet += @{'extension'=                @{'neq'=$ExtensionNot}}}
            if ($Domains)              {$filterSet += @{'collaborators.withDomain'= @{'eq'=$Domains}}}
            if ($DomainsNot)           {$filterSet += @{'collaborators.withDomain'= @{'neq'=$DomainsNot}}}
            if ($Collaborators)        {$filterSet += @{'collaborators.users'=      @{'eq'=$Collaborators}}}
            if ($CollaboratorsNot)     {$filterSet += @{'collaborators.users'=      @{'neq'=$CollaboratorsNot}}}
            if ($Owner)                {$filterSet += @{'owner.username'=           @{'eq'=$Owner}}}
            if ($OwnerNot)             {$filterSet += @{'owner.username'=           @{'neq'=$OwnerNot}}}
            if ($PolicyId)             {$filterSet += @{'policy'=                   @{'cabinetmatchedrulesequals'=$PolicyId}}}
            if ($MIMEType)             {$filterSet += @{'mimeType'=                 @{'eq'=$MIMEType}}}
            if ($MIMETypeNot)          {$filterSet += @{'mimeType'=                 @{'neq'=$MIMETypeNot}}}
            if ($Name)                 {$filterSet += @{'filename'=                 @{'eq'=$Name}}}
            if ($NameWithoutExtension) {$filterSet += @{'filename'=                 @{'text'=$NameWithoutExtension}}}
            if ($Folders)              {$filterSet += @{'folder'=                   @{'eq'=$true}}}
            if ($FoldersNot)           {$filterSet += @{'folder'=                   @{'eq'=$false}}}
            if ($Quarantined)          {$filterSet += @{'quarantined'=              @{'eq'=$true}}}
            if ($QuarantinedNot)       {$filterSet += @{'quarantined'=              @{'eq'=$false}}}
            if ($Trashed)              {$filterSet += @{'trashed'=                  @{'eq'=$true}}}
            if ($TrashedNot)           {$filterSet += @{'trashed'=                  @{'eq'=$false}}}
            if ($FileLabel)            {$filterSet += @{'fileLabels'=               @{'eq'=$FileLabel}}}
            if ($FileLabelNot)         {$filterSet += @{'fileLabels'=               @{'neq'=$FileLabel}}}

            #endregion ----------------------------FILTERING----------------------------

            $collection = @()
            $i = $Skip
            if ($ResultSetSize -gt 100){
            do{

            $body = @{'skip'=$i;'limit'=100} # Base request body
            # Get the matching items and handle errors
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/files/" -Body $body -Method Post -FilterSet $filterSet -Raw
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
                $response = $response.Replace('"Created":','"Created_2":')
                $response = $response.Replace('"ftags":','"ftags_2":')
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

        }
        while($i -lt $ResultSetSize + $skip - $ResultSetSizeSecondaryChunks)
    }



        if ($ResultSetSizeSecondaryChunks -gt 0){
            $body = @{'skip'=($ResultSetSize - $ResultSetSizeSecondaryChunks);'limit'=$ResultSetSizeSecondaryChunks}
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/files/" -Body $body -Method Post -FilterSet $filterSet -Raw
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
                $response = $response.Replace('"Created":','"Created_2":')
                $response = $response.Replace('"ftags":','"ftags_2":')
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

        else{

            # Get the matching items and handle errors
            try {
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/files/" -Body $body -Method Post -FilterSet $filterSet -Raw
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
                $response = $response.Replace('"Created":','"Created_2":')
                $response = $response.Replace('"ftags":','"ftags_2":')
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
    }
}