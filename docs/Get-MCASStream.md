---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASStream

## SYNOPSIS
Get-MCASStream retrieves a list of available discovery streams.

## SYNTAX

```
Get-MCASStream [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Discovery streams are used to separate or aggregate discovery data.
Stream ID's are needed when pulling discovered app data.

## EXAMPLES

### EXAMPLE 1
```
(Get-MCASStream | ?{$_.displayName -eq 'Global View'})._id
```

57869acdb4b3d5154f095af7

This example retrives the global stream ID.

## PARAMETERS

### -Credential
Specifies the credential object containing tenant as username (e.g.
'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $CASCredential
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
