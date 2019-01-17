---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASAppInfo

## SYNOPSIS
Gets all General, Security, and Compliance info for a provided app ID.

## SYNTAX

```
Get-MCASAppInfo [-Credential <PSCredential>] [-AppId] <Int32[]> [-ResultSetSize <Int32>] [-Skip <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
By passing in an App Id, the user can retrive information about those apps straight from the SaaS DB.
This information is returned in an object format that can be formatted for the user's needs.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASAppInfo -AppId 11114 | select name, category
```

name       category
----       --------
Salesforce SAASDB_CATEGORY_CRM

### EXAMPLE 2
```
Get-MCASAppInfo -AppId 18394 | select name, @{N='Compliance';E={"{0:N0}" -f $_.revised_score.compliance}}, @{N='Security';E={"{0:N0}" -f $_.revised_score.security}}, @{N='Provider';E={"{0:N0}" -f $_.revised_score.provider}}, @{N='Total';E={"{0:N0}" -f $_.revised_score.total}} | ft
```

name        Compliance Security Provider Total
----        ---------- -------- -------- -----
Blue Coat   4          8        6        6

This example creates a table with just the app name and high level scores.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
