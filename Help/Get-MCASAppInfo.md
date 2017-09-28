---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Get-MCASAppInfo

## SYNOPSIS
Gets all General, Security, and Compliance info for a provided app ID.

## SYNTAX

```
Get-MCASAppInfo [-TenantUri <String>] [-Credential <PSCredential>] [-ResultSetSize <Int32>] [-Skip <Int32>]
 [-AppId] <Int32[]>
```

## DESCRIPTION
By passing in an App Id, the user can retrive information about those apps straight from the SaaS DB.
This information is returned in an object format that can be formatted for the user's needs.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-MCASAppInfo -AppId 11114 | select name, category
```

name       category
----       --------
Salesforce SAASDB_CATEGORY_CRM

### -------------------------- EXAMPLE 2 --------------------------
```
Get-MCASAppInfo -AppId 18394 | select name, @{N='Compliance';E={"{0:N0}" -f $_.revised_score.compliance}}, @{N='Security';E={"{0:N0}" -f $_.revised_score.security}}, @{N='Provider';E={"{0:N0}" -f $_.revised_score.provider}}, @{N='Total';E={"{0:N0}" -f $_.revised_score.total}} | ft
```

name        Compliance Security Provider Total
----        ---------- -------- -------- -----
Blue Coat   4          8        6        6

This example creates a table with just the app name and high level scores.

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

### -AppId
Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: Service, Services

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

