---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASDiscoveredApp

## SYNOPSIS
Gets a list of discovered apps based on uploaded log files.

## SYNTAX

```
Get-MCASDiscoveredApp [-Credential <PSCredential>] [-SortBy <String>] [-SortDirection <String>]
 [-ResultSetSize <Int32>] [-Skip <Int32>] [-Category <app_category>] [-ScoreRange <String>]
 [[-StreamId] <String>] [-TimeFrame <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This function retrives traffic and usage information about discovered apps.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASDiscoveredApp -StreamId $streamid | select name -First 5
```

name
----
1ShoppingCart
ABC News
ACTIVE
AIM
AT&T

Retrieves the first 5 app names sorted alphabetically.

### EXAMPLE 2
```
Get-MCASDiscoveredApp -StreamId $streamid -Category SECURITY | select name,@{N='Total (MB)';E={"{0:N2}" -f ($_.trafficTotalBytes/1MB)}}
```

name                   Total (MB)
----                   ----------
Blue Coat              19.12
Globalscape            0.00
McAfee Control Console 1.28
Symantec               0.20
Websense               0.06

In this example we pull back only discovered apps in the security category and display a table of names and Total traffic which we format to 2 decimal places and divide the totalTrafficBytes property by 1MB to show the traffic in MB.

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

### -SortBy
Specifies the property by which to sort the results.
Set to 'Name' by default.
Possible Values: 'UserName','LastSeen'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortDirection
Specifies the direction in which to sort the results.
Set to 'Ascending' by default.
Possible Values: 'Ascending','Descending'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Ascending
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResultSetSize
Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
Set to 100 by default.

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
Set to 0 by default.

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

### -Category
Limits results by category type.
A preset list of categories are included.
\[app_category\[\]\]$Category, # I dont think an array will work here, so i am commmenting this out for now

```yaml
Type: app_category
Parameter Sets: (All)
Aliases:
Accepted values: ACCOUNTING_AND_FINANCE, ADVERTISING, BUSINESS_MANAGEMENT, CLOUD_STORAGE, CODE_HOSTING, COLLABORATION, COMMUNICATIONS, CONTENT_MANAGEMENT, CONTENT_SHARING, CRM, CUSTOMER_SUPPORT, DATA_ANALYTICS, DEVELOPMENT_TOOLS, ECOMMERCE, EDUCATION, FORUMS, HEALTH, HOSTING_SERVICES, HUMAN_RESOURCE_MANAGEMENT, IT_SERVICES, MARKETING, MEDIA, NEWS_AND_ENTERTAINMENT, ONLINE_MEETINGS, OPERATIONS_MANAGEMENT, PRODUCT_DESIGN, PRODUCTIVITY, PROJECT_MANAGEMENT, PROPERTY_MANAGEMENT, SALES, SECURITY, SOCIAL_NETWORK, SUPLLY_CHAIN_AND_LOGISTICS, TRANSPORTATION_AND_TRAVEL, VENDOR_MANAGEMENT_SYSTEM, WEB_ANALYTICS, WEBMAIL, WEBSITE_MONITORING

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScoreRange
Limits the results by risk score range, for example '3-9'.
Set to '1-10' by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1-10
Accept pipeline input: False
Accept wildcard characters: False
```

### -StreamId
Limits the results by stream ID, for example '577d49d72b1c51a0762c61b0'.
The stream ID can be found in the URL bar of the console when looking at the Discovery dashboard.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeFrame
Limits the results by time frame in days.
Set to 90 days by default.
(Options: 7, 30, or 90)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 90
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
