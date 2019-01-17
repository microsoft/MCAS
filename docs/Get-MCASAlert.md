---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASAlert

## SYNOPSIS
Gets alert information from your Cloud App Security tenant.

## SYNTAX

### Fetch
```
Get-MCASAlert [-Credential <PSCredential>] [-Identity] <String> [<CommonParameters>]
```

### List
```
Get-MCASAlert [-Credential <PSCredential>] [-SortBy <String>] [-SortDirection <String>]
 [-ResultSetSize <Int32>] [-Skip <Int32>] [-Severity <severity_level[]>]
 [-ResolutionStatus <resolution_status[]>] [-UserName <String[]>] [-AppId <Int32[]>] [-AppName <mcas_app[]>]
 [-AppIdNot <Int32[]>] [-AppNameNot <mcas_app[]>] [-Policy <String[]>] [-Risk <Int32[]>] [-Source <String>]
 [-Read] [-Unread] [<CommonParameters>]
```

## DESCRIPTION
Gets alert information from your Cloud App Security tenant and requires a credential be provided.

Without parameters, Get-MCASAlert gets 100 alert records and associated properties.
You can specify a particular alert GUID to fetch a single alert's information or you can pull a list of activities based on the provided filters.

Get-MCASAlert returns a single custom PS Object or multiple PS Objects with all of the alert properties.
Methods available are only those available to custom objects by default.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASAlert -ResultSetSize 1
```

This pulls back a single alert record and is part of the 'List' parameter set.

### EXAMPLE 2
```
Get-MCASAlert -Identity 572caf4588011e452ec18ef0
```

This pulls back a single alert record using the GUID and is part of the 'Fetch' parameter set.

### EXAMPLE 3
```
(Get-MCASAlert -ResolutionStatus Open -Severity High | where{$_.title -match "system alert"}).descriptionTemplate.parameters.LOGRABBER_SYSTEM_ALERT_MESSAGE_BASE.functionObject.parameters.appName
```

ServiceNow
Box

This command showcases the ability to expand nested tables of alerts.
First, we pull back only Open alerts marked as High severity and filter down to only those with a title that matches "system alert".
By wrapping the initial call in parentheses you can now extract the names of the affected services by drilling into the nested tables and referencing the appName property.

## PARAMETERS

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

### -Identity
Fetches an alert object by its unique identifier.

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

### -SortBy
Specifies the property by which to sort the results.
Possible Values: 'Date','Severity', 'ResolutionStatus'.
\[ValidateSet('Date','Severity','ResolutionStatus')\] # Additional sort fields removed by PG

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

### -Severity
Limits the results by severity.
Possible Values: 'High','Medium','Low'.

```yaml
Type: severity_level[]
Parameter Sets: List
Aliases:
Accepted values: Low, Medium, High

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResolutionStatus
Limits the results to items with a specific resolution status.
Possible Values: 'Open','Dismissed','Resolved'.

```yaml
Type: resolution_status[]
Parameter Sets: List
Aliases:
Accepted values: Open, Dismissed, Resolved

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Limits the results to items related to the specified user/users, such as 'alice@contoso.com','bob@contoso.com'.

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

### -Policy
Limits the results to items related to the specified policy ID, such as 57595d0ba6b5d8cd76d6be8c.

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

### -Risk
Limits the results to items with a specific risk score.
The valid range is 1-10.

```yaml
Type: Int32[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
Limits the results to items from a specific source.

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

### -Read
Limits the results to read items.

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

### -Unread
Limits the results to unread items.

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
