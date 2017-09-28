---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Get-MCASAccount

## SYNOPSIS
Gets user account information from your Cloud App Security tenant.

## SYNTAX

```
Get-MCASAccount [-TenantUri <String>] [-Credential <PSCredential>] [-SortBy <String>] [-SortDirection <String>]
 [-ResultSetSize <Int32>] [-Skip <Int32>] [-External] [-Internal] [-UserName <String[]>] [-AppId <Int32[]>]
 [-AppName <mcas_app[]>] [-AppIdNot <Int32[]>] [-AppNameNot <mcas_app[]>] [-UserDomain <String[]>]
```

## DESCRIPTION
Gets user account information from your Cloud App Security tenant and requires a credential be provided.

Without parameters, Get-MCASAccount gets 100 account records and associated properties.
You can specify a particular account GUID to fetch a single account's information or you can pull a list of accounts based on the provided filters.

Get-MCASAccount returns a single custom PS Object or multiple PS Objects with all of the account properties.
Methods available are only those available to custom objects by default.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-MCASAccount -ResultSetSize 1
```

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

### -------------------------- EXAMPLE 2 --------------------------
```
(Get-MCASAccount -UserDomain contoso.com).count
```

2

 This pulls back all accounts from the specified domain and returns a count of the returned objects.

### -------------------------- EXAMPLE 3 --------------------------
```
Get-MCASAccount -Affiliation External | select @{N='Unique Domains'; E={$_.userDomain}} -Unique
```

Unique Domains
 --------------
 gmail.com
 outlook.com
 yahoo.com

 This pulls back all accounts flagged as external to the domain and displays only unique records in a new property called 'Unique Domains'.

### -------------------------- EXAMPLE 4 --------------------------
```
(Get-MCASAccount -ServiceNames 'Microsoft Cloud App Security').serviceData.20595
```

email                              lastLogin                   lastSeen
 -----                              ---------                   --------
 admin@mod.onmicrosoft.com          2016-06-13T21:17:40.821000Z 2016-06-13T21:17:40.821000Z

 This queries for any Cloud App Security accounts and displays the serviceData table containing the email, last login, and last seen properties.
20595 is the Service ID for Cloud App Security.

## PARAMETERS

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
Possible Values: 'UserName','LastSeen'.

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

### -SortDirection
Specifies the direction in which to sort the results.
Possible Values: 'Ascending','Descending'.

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

### -ResultSetSize
Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.

```yaml
Type: Int32
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -External
Limits the results to external users

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Internal
Limits the results to internal users

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Limits the results to items related to the specified user names, such as 'alice@contoso.com','bob@contoso.com'.

```yaml
Type: String[]
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases: ServiceNameNot, ServiceNamesNot
Accepted values: Box, Okta, Salesforce, Office_365, Microsoft_Yammer, Amazon_Web_Services, Dropbox, Google_Apps, ServiceNow, Microsoft_OneDrive_for_Business, Microsoft_Cloud_App_Security, Microsoft_Sharepoint_Online, Microsoft_Exchange_Online, Microsoft_Skype_for_Business, Microsoft_Power_BI, Microsoft_Teams

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserDomain
Limits the results to items found in the specified user domains, such as 'contoso.com'.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

