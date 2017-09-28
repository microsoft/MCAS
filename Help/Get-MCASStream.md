---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Get-MCASStream

## SYNOPSIS
Get-MCASStream retrieves a list of available discovery streams.

## SYNTAX

```
Get-MCASStream [[-TenantUri] <String>] [[-Credential] <PSCredential>]
```

## DESCRIPTION
Discovery streams are used to separate or aggregate discovery data.
Stream ID's are needed when pulling discovered app data.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
(Get-MCASStream | ?{$_.displayName -eq 'Global View'})._id
```

57869acdb4b3d5154f095af7

This example retrives the global stream ID.

## PARAMETERS

### -TenantUri
Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

