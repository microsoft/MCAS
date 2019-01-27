---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASGovernanceAction

## SYNOPSIS
Get-MCASGovernanceLog retrives governance log entries.

## SYNTAX

### Fetch
```
Get-MCASGovernanceAction [-Identity] <String> [-Credential <PSCredential>] [<CommonParameters>]
```

### List
```
Get-MCASGovernanceAction [-Credential <PSCredential>] [-SortBy <String>] [-SortDirection <String>]
 [-ResultSetSize <Int32>] [-Skip <Int32>] [-AppId <Int32[]>] [-AppName <mcas_app[]>] [-AppIdNot <Int32[]>]
 [-AppNameNot <mcas_app[]>] [-Action <String[]>] [-Status <String[]>] [<CommonParameters>]
```

## DESCRIPTION
The MCAS governance log contains entries for when the product performs an action such as parsing log files or quarantining files.
This function retrives those entries.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASGovernanceLog -ResultSetSize 10 -Status Successful,Failed -AppName Microsoft_Cloud_App_Security | select taskname, @{N='Status';E={$_.status.isSuccess}}
```

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

## PARAMETERS

### -Identity
Fetches an activity object by its unique identifier.
\[ValidatePattern('((\d{8}_\d{5}_\[0-9a-f\]{8}-(\[0-9a-f\]{4}-){3}\[0-9a-f\]{12})|(\[A-Za-z0-9\]{20}))')\]

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
Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.

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

### -Action
Limits the results to events listed for the specified File ID.

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

### -Status
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
