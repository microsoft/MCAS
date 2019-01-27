---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Remove-MCASAdminAccess

## SYNOPSIS
Removes administrators from the MCAS portal.

## SYNTAX

```
Remove-MCASAdminAccess [-Credential <PSCredential>] [-Username] <String> [<CommonParameters>]
```

## DESCRIPTION
Removce-MCASAdminAccess removes explicit MCAS admin roles from users assigned them within MCAS.

## EXAMPLES

### EXAMPLE 1
```
Remove-MCASAdminAccess -Username 'alice@contoso.com'
```

### EXAMPLE 2
```
Remove-MCASAdminAccess 'bob@contoso.com'
```

## PARAMETERS

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

### -Username
{{Fill Username Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
