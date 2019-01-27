---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# ConvertFrom-MCASTimestamp

## SYNOPSIS
Converts an MCAS timestamp (13-digit integer or 10-digit integer) to a native date/time value of type \[datetime\].

## SYNTAX

```
ConvertFrom-MCASTimestamp [-Timestamp] <Object> [<CommonParameters>]
```

## DESCRIPTION
ConvertFrom-MCASTimestamp returns a System.DateTime value representing the time (localized to the Powershell session's timezone) for a timestamp value from MCAS.

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-MCASTimestamp 1520272590839
```

Monday, March 5, 2018 12:56:30 PM

### EXAMPLE 2
```
Get-MCASActivity -ResultSetSize 5 | ForEach-Object {ConvertFrom-MCASTimestamp $_.timestamp}
```

Monday, March 5, 2018 12:56:30 PM
Monday, March 5, 2018 12:50:28 PM
Monday, March 5, 2018 12:49:34 PM
Monday, March 5, 2018 12:45:36 PM
Monday, March 5, 2018 12:45:23 PM

## PARAMETERS

### -Timestamp
{{Fill Timestamp Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.DateTime

## NOTES

## RELATED LINKS
