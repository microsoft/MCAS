---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Set-MCASAlert

## SYNOPSIS
Sets the status of alerts in Cloud App Security.

## SYNTAX

### MarkAs
```
Set-MCASAlert [-Identity] <String> [-MarkAs] <String> [-TenantUri <String>] [-Credential <PSCredential>]
 [-Quiet]
```

### Dismiss
```
Set-MCASAlert [-Identity] <String> [-Dismiss] [-TenantUri <String>] [-Credential <PSCredential>] [-Quiet]
```

## DESCRIPTION
Sets the status of alerts in Cloud App Security and requires a credential be provided.

There are two parameter sets:

MarkAs: Used for marking an alert as 'Read' or 'Unread'.
Dismiss: Used for marking an alert as 'Dismissed'.

An alert identity is always required to be specified either explicity or implicitly from the pipeline.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -MarkAs Read
```

This marks a single specified alert as 'Read'.

### -------------------------- EXAMPLE 2 --------------------------
```
Set-MCASAlert -Identity cac1d0ec5734e596e6d785cc -Dismiss
```

This will set the status of the specified alert as "Dismissed".

## PARAMETERS

### -Identity
Specifies an alert object by its unique identifier.
\[ValidatePattern({^\[A-Fa-f0-9\]{24}$})\]

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

### -MarkAs
Specifies how to mark the alert.
Possible Values: 'Read', 'Unread'.

```yaml
Type: String
Parameter Sets: MarkAs
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dismiss
Specifies that the alert should be dismissed.

```yaml
Type: SwitchParameter
Parameter Sets: Dismiss
Aliases: 

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantUri
Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.

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

### -Credential
Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

