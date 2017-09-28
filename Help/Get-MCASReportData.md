---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Get-MCASReportData

## SYNOPSIS
Get-MCASReportData retrieves built-in reports from Cloud App Security.

## SYNTAX

```
Get-MCASReportData [-ReportName] <String> [-TenantUri <String>] [-Credential <PSCredential>]
```

## DESCRIPTION
Retrieves report data from the built-in reports.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-MCASReportData -ReportName 'Browser Use' | select @{N='Browser';E={$_.unique_identifier}}, @{N='User Count';E={$_.record_data.users.count}} | sort -Property 'User Count' -Descending
```

Browser                               User Count
-------                               ----------
chrome_53.0.2785.143                           4
chrome_54.0.2840.71                            4
unknown_                                       4
microsoft bits_7.8                             3
microsoft exchange_                            3
microsoft exchange rpc_                        2
edge_14.14393                                  2
ie_11.0                                        2
microsoft onenote_16.0.7369.5783               1
apache-httpclient_4.3.5                        1
ie_9                                           1
skype for business_16.0.7369.2038              1
mobile safari_10.0                             1
microsoft web application companion_           1
chrome_54.0.2840.87                            1
microsoft excel_1.26.1007                      1
microsoft skydrivesync_17.3.6517.0809          1

This example retrives the Browser Use report, shows the browser name and user count columns, and sorts by user count descending.

## PARAMETERS

### -ReportName
Fetches a report by its unique name identifier.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FriendlyName

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

