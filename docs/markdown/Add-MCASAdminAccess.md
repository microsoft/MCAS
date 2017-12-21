---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Add-MCASAdminAccess

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Add-MCASAdminAccess [-TenantUri <String>] [-Credential <PSCredential>] [-Username] <String>
 [-PermissionType] <permission_type>
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Credential
{{Fill Credential Description}}

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

### -PermissionType
{{Fill PermissionType Description}}

```yaml
Type: permission_type
Parameter Sets: (All)
Aliases: 
Accepted values: READ_ONLY, FULL_ACCESS

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TenantUri
{{Fill TenantUri Description}}

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

### -Username
{{Fill Username Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.String
permission_type


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

