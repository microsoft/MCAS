---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Remove-MCASSubnetCollection

## SYNOPSIS
Removes a subnet collection in MCAS, as specified by its unique id

## SYNTAX

### ById
```
Remove-MCASSubnetCollection [-Credential <PSCredential>] [-Identity] <String> [-Quiet] [<CommonParameters>]
```

### ByName
```
Remove-MCASSubnetCollection [-Credential <PSCredential>] -Name <String> [-Quiet] [<CommonParameters>]
```

## DESCRIPTION
Remove-MCASSubnetCollection deletes subnet collections in the MCAS tenant.

## EXAMPLES

### EXAMPLE 1
```
Remove-MCASSubnetCollection -Identity '5a9e04c7f82b1bb8af51c7fb'
```

### EXAMPLE 2
```
Get-MCASSubnetCollection | Remove-MCASSubnetCollection
```

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
{{Fill Identity Description}}

```yaml
Type: String
Parameter Sets: ById
Aliases: _id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
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
