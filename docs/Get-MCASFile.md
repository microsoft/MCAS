---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASFile

## SYNOPSIS
Gets file information from your Cloud App Security tenant.

## SYNTAX

### Fetch
```
Get-MCASFile [-Identity] <String> [-Credential <PSCredential>] [<CommonParameters>]
```

### List
```
Get-MCASFile [-Credential <PSCredential>] [-SortBy <String>] [-SortDirection <String>] [-ResultSetSize <Int32>]
 [-Skip <Int32>] [-Filetype <file_type[]>] [-FiletypeNot <file_type[]>]
 [-FileAccessLevel <file_access_level[]>] [-FileLabel <Array>] [-FileLabelNot <Array>]
 [-Collaborators <String[]>] [-CollaboratorsNot <String[]>] [-Owner <String[]>] [-OwnerNot <String[]>]
 [-PolicyId <String[]>] [-MIMEType <String>] [-MIMETypeNot <String>] [-Domains <String[]>]
 [-DomainsNot <String[]>] [-AppId <Int32[]>] [-AppName <mcas_app[]>] [-AppIdNot <Int32[]>]
 [-AppNameNot <mcas_app[]>] [-Name <String>] [-NameWithoutExtension <String>] [-Extension <String>]
 [-ExtensionNot <String>] [-Trashed] [-TrashedNot] [-Quarantined] [-QuarantinedNot] [-Folders] [-FoldersNot]
 [<CommonParameters>]
```

## DESCRIPTION
Gets file information from your Cloud App Security tenant and requires a credential be provided.

Without parameters, Get-MCASFile gets 100 file records and associated properties.
You can specify a particular file GUID to fetch a single file's information or you can pull a list of activities based on the provided filters.

Get-MCASFile returns a single custom PS Object or multiple PS Objects with all of the file properties.
Methods available are only those available to custom objects by default.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASFile -ResultSetSize 1
```

This pulls back a single file record and is part of the 'List' parameter set.

### EXAMPLE 2
```
Get-MCASFile -Identity 572caf4588011e452ec18ef0
```

This pulls back a single file record using the GUID and is part of the 'Fetch' parameter set.

### EXAMPLE 3
```
Get-MCASFile -AppName Box -Extension pdf -Domains 'microsoft.com' | select name
```

name                      dlpScanTime
----                      -----------
pdf_creditcardnumbers.pdf 2016-06-08T19:00:36.534000Z
mytestdoc.pdf             2016-06-12T22:00:45.235000Z
powershellrules.pdf       2016-06-03T13:00:19.776000Z

This searches Box files for any PDF documents owned by any user in the microsoft.com domain and returns the names of those documents and the last time they were scanned for DLP violations.

## PARAMETERS

### -Identity
Fetches a file object by its unique identifier.
\[ValidatePattern({^\[A-Fa-f0-9\]{24}$})\]

```yaml
Type: String
Parameter Sets: Fetch
Aliases: _id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Credential
Specifies the credential object containing tenant as username (e.g.
'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $CASCredential
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortBy
Specifies the property by which to sort the results.
Possible Value: 'DateModified'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortDirection
Specifies the direction in which to sort the results.
Possible Values: 'Ascending','Descending'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResultSetSize
Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
Specifies the number of records, from the beginning of the result set, to skip.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filetype
Limits the results to items of the specified file type.
Value Map: 0 = Other,1 = Document,2 = Spreadsheet, 3 = Presentation, 4 = Text, 5 = Image, 6 = Folder.

```yaml
Type: file_type[]
Parameter Sets: List
Aliases:
Accepted values: Other, Document, Spreadsheet, Presentation, Text, Image, Folder

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FiletypeNot
Limits the results to items not of the specified file type.
Value Map: 0 = Other,1 = Document,2 = Spreadsheet, 3 = Presentation, 4 = Text, 5 = Image, 6 = Folder.

```yaml
Type: file_type[]
Parameter Sets: List
Aliases:
Accepted values: Other, Document, Spreadsheet, Presentation, Text, Image, Folder

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileAccessLevel
Limits the results to items of the specified sharing access level.
Possible Values: 'Private','Internal','External','Public', 'PublicInternet'.

```yaml
Type: file_access_level[]
Parameter Sets: List
Aliases:
Accepted values: Private, Internal, External, Public, PublicInternet

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileLabel
Limits the results to files listed for the specified AIP classification labels.
Use ^ when denoting (external) labels.
Example: @("^Private")

```yaml
Type: Array
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileLabelNot
Limits the results to files excluded by the specified AIP classification labels.
Use ^ when denoting (external) labels.
Example: @("^Private")

```yaml
Type: Array
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Collaborators
Limits the results to items with the specified collaborator usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollaboratorsNot
Limits the results to items without the specified collaborator usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Owner
Limits the results to items with the specified owner usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OwnerNot
Limits the results to items without the specified owner usernames, such as 'alice@contoso.com', 'bob@microsoft.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyId
Limits the results to items with the specified policy ids, such as '59c1954dbff351a11ae56fe2', '59a8657ebff351ba49d5955f'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MIMEType
Limits the results to items with the specified MIME Type, such as 'text/plain', 'image/vnd.adobe.photoshop'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MIMETypeNot
Limits the results to items without the specified MIME Type, such as 'text/plain', 'image/vnd.adobe.photoshop'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domains
Limits the results to items shared with the specified domains, such as 'contoso.com', 'microsoft.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainsNot
Limits the results to items not shared with the specified domains, such as 'contoso.com', 'microsoft.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppId
Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).

```yaml
Type: Int32[]
Parameter Sets: List
Aliases: Service, Services

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppName
Limits the results to items related to the specified service names, such as 'Office_365' and 'Google_Apps'.

```yaml
Type: mcas_app[]
Parameter Sets: List
Aliases: ServiceName, ServiceNames
Accepted values: Box, Okta, Salesforce, Office_365, Microsoft_Yammer, Amazon_Web_Services, Dropbox, Google_Apps, ServiceNow, Microsoft_OneDrive_for_Business, Microsoft_Cloud_App_Security, Microsoft_Sharepoint_Online, Microsoft_Exchange_Online, Microsoft_Skype_for_Business, Microsoft_Power_BI, Microsoft_Teams

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppIdNot
Limits the results to items not related to the specified service ids, such as 11161,11770 (for Office 365 and Google Apps, respectively).

```yaml
Type: Int32[]
Parameter Sets: List
Aliases: ServiceNot, ServicesNot

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppNameNot
Limits the results to items not related to the specified service names, such as 'Office_365' and 'Google_Apps'.

```yaml
Type: mcas_app[]
Parameter Sets: List
Aliases: ServiceNameNot, ServiceNamesNot
Accepted values: Box, Okta, Salesforce, Office_365, Microsoft_Yammer, Amazon_Web_Services, Dropbox, Google_Apps, ServiceNow, Microsoft_OneDrive_for_Business, Microsoft_Cloud_App_Security, Microsoft_Sharepoint_Online, Microsoft_Exchange_Online, Microsoft_Skype_for_Business, Microsoft_Power_BI, Microsoft_Teams

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Limits the results to items with the specified file name with extension, such as 'My Microsoft File.txt'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameWithoutExtension
Limits the results to items with the specified file name without extension, such as 'My Microsoft File'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extension
Limits the results to items with the specified file extensions, such as 'jpg', 'txt'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensionNot
Limits the results to items without the specified file extensions, such as 'jpg', 'txt'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Trashed
Limits the results to items that CAS has marked as trashed.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TrashedNot
Limits the results to items that CAS has marked as not trashed.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quarantined
Limits the results to items that CAS has marked as quarantined.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantinedNot
Limits the results to items that CAS has marked as not quarantined.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folders
Limits the results to items that CAS has marked as a folder.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FoldersNot
Limits the results to items that CAS has marked as not a folder.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
