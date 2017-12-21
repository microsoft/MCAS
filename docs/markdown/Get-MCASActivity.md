---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Get-MCASActivity

## SYNOPSIS
Gets user activity information from your Cloud App Security tenant.

## SYNTAX

### Fetch
```
Get-MCASActivity [-Identity] <String> [-TenantUri <String>] [-Credential <PSCredential>]
```

### List
```
Get-MCASActivity [-TenantUri <String>] [-Credential <PSCredential>] [-SortBy <String>]
 [-SortDirection <String>] [-ResultSetSize <Int32>] [-Skip <Int32>] [-UserName <String[]>] [-AppId <Int32[]>]
 [-AppName <mcas_app[]>] [-AppIdNot <Int32[]>] [-AppNameNot <mcas_app[]>] [-EventTypeName <String[]>]
 [-EventTypeNameNot <String[]>] [-IpCategory <ip_category[]>] [-IpStartsWith <String[]>]
 [-IpDoesNotStartWith <String>] [-DateBefore <DateTime>] [-DateAfter <DateTime>] [-DeviceType <String[]>]
 [-Text <String>] [-FileID <String>] [-FileLabel <Array>] [-FileLabelNot <Array>] [-IPTag <String[]>]
 [-CountryCodePresent] [-PolicyId <String>] [-DaysAgo <Int32>] [-AdminEvents] [-NonAdminEvents] [-Impersonated]
 [-ImpersonatedNot]
```

## DESCRIPTION
Gets user activity information from your Cloud App Security tenant and requires a credential be provided.

Without parameters, Get-MCASActivity gets 100 activity records and associated properties.
You can specify a particular activity GUID to fetch a single activity's information or you can pull a list of activities based on the provided filters.

Get-MCASActivity returns a single custom PS Object or multiple PS Objects with all of the activity properties.
Methods available are only those available to custom objects by default.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-MCASActivity -ResultSetSize 1
```

This pulls back a single activity record and is part of the 'List' parameter set.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-MCASActivity -Identity 572caf4588011e452ec18ef0
```

This pulls back a single activity record using the GUID and is part of the 'Fetch' parameter set.

### -------------------------- EXAMPLE 3 --------------------------
```
(Get-MCASActivity -AppName Box).rawJson | ?{$_.event_type -match "upload"} | select ip_address -Unique
```

ip_address
 ----------
 69.4.151.176
 98.29.2.44

 This grabs the last 100 Box activities, searches for an event type called "upload" in the rawJson table, and returns a list of unique IP addresses.

## PARAMETERS

### -Identity
Fetches an activity object by its unique identifier.
\[ValidatePattern("\[A-Fa-f0-9_\-\]{51}|\[A-Za-z0-9_\-\]{20}")\]

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

### -TenantUri
Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortBy
Specifies the property by which to sort the results.
Possible Values: 'Date','Created'.

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

### -UserName
-User limits the results to items related to the specified user/users, for example 'alice@contoso.com','bob@contoso.com'.

```yaml
Type: String[]
Parameter Sets: List
Aliases: User

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

### -EventTypeName
Limits the results to items of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.

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

### -EventTypeNameNot
Limits the results to items not of specified event type name, such as EVENT_CATEGORY_LOGIN,EVENT_CATEGORY_DOWNLOAD_FILE.

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

### -IpCategory
Limits the results by ip category.
Possible Values: 'None','Internal','Administrative','Risky','VPN','Cloud_Provider'.

```yaml
Type: ip_category[]
Parameter Sets: List
Aliases: 
Accepted values: None, Internal, Administrative, Risky, VPN, Cloud_Provider

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IpStartsWith
Limits the results to items with the specified IP leading digits, such as 10.0.

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

### -IpDoesNotStartWith
Limits the results to items without the specified IP leading digits, such as 10.0.

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

### -DateBefore
Limits the results to items found before specified date.
Use Get-Date.

```yaml
Type: DateTime
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DateAfter
Limits the results to items found after specified date.
Use Get-Date.

```yaml
Type: DateTime
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceType
Limits the results by device type.
Possible Values: 'Desktop','Mobile','Tablet','Other'.

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

### -Text
Limits the results by performing a free text search

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

### -FileID
Limits the results to events listed for the specified File ID.
\[ValidatePattern("\b\[A-Za-z0-9\]{24}\b")\]

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

### -FileLabel
Limits the results to events listed for the specified AIP classification labels.
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
Limits the results to events excluded by the specified AIP classification labels.
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

### -IPTag
Limits the results to events listed for the specified IP Tags.

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

### -CountryCodePresent
Limits the results to events that include a country code value.

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

### -PolicyId
Limits the results to events listed for the specified IP Tags.
\[ValidatePattern("\[A-Fa-f0-9\]{24}")\]

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

### -DaysAgo
Limits the results to items occuring in the last x number of days.

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

### -AdminEvents
Limits the results to admin events if specified.

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

### -NonAdminEvents
Limits the results to non-admin events if specified.

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

### -Impersonated
Limits the results to impersonated events if specified.

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

### -ImpersonatedNot
Limits the results to non-impersonated events if specified.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

