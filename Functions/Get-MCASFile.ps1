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
        # Fetches a file object by its unique identifier.
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
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0,


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
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/files/$Identity/" -Method Get -Token $Token
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
            If ($SortBy -eq 'DateModified')
            {
                $Body.Add('sortField','dateModified') # Patch to convert 'DateModified' to 'dateModified' for API compatibility. There is only one Sort Field today.
            }
            #endregion ----------------------------SORTING----------------------------

            #region ----------------------------FILTERING----------------------------
            $FilterSet = @() # Filter set array

            # Additional Hash Tables for Filetype & FiletypeNot Filters
            If ($Filetype){
                $Filetypehashtable = @{}
                $Filetype | ForEach-Object {$Filetypehashtable.Add($_,$_)}
                }
            If ($FiletypeNot){
                $Filetypehashtable = @{}
                $FiletypeNot | ForEach-Object {$Filetypehashtable.Add($_,$_)}
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
            If ($Filetype)        {$FilterSet += @{'fileType'=@{'eq'= ($Filetype | ForEach-Object {$_ -as [int]})}}}
            If ($FiletypeNot)     {$FilterSet += @{'fileType'=@{'neq'=($FiletypeNot | ForEach-Object {$_ -as [int]})}}}
            If ($FileAccessLevel) {$FilterSet += @{'sharing'= @{'eq'= ($FileAccessLevel | ForEach-Object {$_ -as [int]})}}}
            If ($AppName)         {$FilterSet += @{'service'= @{'eq'= ($AppName | ForEach-Object {$_ -as [int]})}}}
            If ($AppNameNot)      {$FilterSet += @{'service'= @{'neq'=($AppNameNot | ForEach-Object {$_ -as [int]})}}}

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
            If ($Folders)              {$FilterSet += @{'folder'=                   @{'eq'=$true}}}
            If ($FoldersNot)           {$FilterSet += @{'folder'=                   @{'eq'=$false}}}
            If ($Quarantined)          {$FilterSet += @{'quarantined'=              @{'eq'=$true}}}
            If ($QuarantinedNot)       {$FilterSet += @{'quarantined'=              @{'eq'=$false}}}
            If ($Trashed)              {$FilterSet += @{'trashed'=                  @{'eq'=$true}}}
            If ($TrashedNot)           {$FilterSet += @{'trashed'=                  @{'eq'=$false}}}
            If ($FileLabel)            {$FilterSet += @{'fileLabels'=               @{'eq'=$FileLabel}}}
            If ($FileLabelNot)         {$FilterSet += @{'fileLabels'=               @{'neq'=$FileLabel}}}

            #endregion ----------------------------FILTERING----------------------------

            # Get the matching items and handle errors
            Try {
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/files/" -Body $Body -Method Post -Token $Token -FilterSet $FilterSet
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
