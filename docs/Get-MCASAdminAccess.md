---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASAdminAccess

## SYNOPSIS
Lists the administrators that have been granted access to the MCAS portal via an MCAS role.
(Does not include admins with Azure AD admin roles, like Global Admin.)

## SYNTAX

```
Get-MCASAdminAccess [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Get-MCASAdminAccess list existing user accounts with MCAS admin rights and the permission type they have within MCAS.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASAdminAccess
```

### EXAMPLE 2
```
Get-MCASAdminAccess 'bob@contoso.com' READ_ONLY
```

username          permission_type
--------          ---------------
alice@contoso.com FULL_ACCESS
bob@contoso.com   READ_ONLY

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
