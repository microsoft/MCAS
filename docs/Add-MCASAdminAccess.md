---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Add-MCASAdminAccess

## SYNOPSIS
Adds administrators to the MCAS portal.

## SYNTAX

```
Add-MCASAdminAccess [-Credential <PSCredential>] [-Username] <String> [-PermissionType] <permission_type>
 [<CommonParameters>]
```

## DESCRIPTION
Add-MCASAdminAccess grants existing user accounts the MCAS full admin or read-only admin role within MCAS.

## EXAMPLES

### EXAMPLE 1
```
Add-MCASAdminAccess -Username 'alice@contoso.com' -PermissionType FULL_ACCESS
```

### EXAMPLE 2
```
Add-MCASAdminAccess 'bob@contoso.com' READ_ONLY
```

WARNING: READ_ONLY acces includes the ability to manage MCAS alerts.

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

### -PermissionType
{{Fill PermissionType Description}}

```yaml
Type: permission_type
Parameter Sets: (All)
Aliases:
Accepted values: READ_ONLY, FULL_ACCESS

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
