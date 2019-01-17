---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Set-MCASAlert

## SYNOPSIS
Sets the status of alerts in Cloud App Security.

## SYNTAX

```
Set-MCASAlert [-Identity] <String> [-Credential <PSCredential>] [-MarkAs <String>] [-Dismiss] [-Quiet]
 [<CommonParameters>]
```

## DESCRIPTION
Sets the status of alerts in Cloud App Security and requires a credential be provided.

There are two parameter sets:

MarkAs: Used for marking an alert as 'Read' or 'Unread'.
Dismiss: Used for marking an alert as 'Dismissed'.

An alert identity is always required to be specified either explicity or implicitly from the pipeline.

## EXAMPLES

### EXAMPLE 1
```
Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -MarkAs Read
```

This marks a single specified alert as 'Read'.

### EXAMPLE 2
```
Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -Dismiss
```

This will set the status of the specified alert as "Dismissed".

## PARAMETERS

### -Identity
Fetches an alert object by its unique identifier.

```yaml
Type: String
Parameter Sets: (All)
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

### -MarkAs
Specifies how to mark the alert.
Possible Values: 'Read', 'Unread'.

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

### -Dismiss
Specifies that the alert should be dismissed.

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

### -Quiet
{{Fill Quiet Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
