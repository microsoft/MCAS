---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# New-MCASSubnetCollection

## SYNOPSIS
Defines new subnet collections in MCAS for enrichment of IP address information.

## SYNTAX

```
New-MCASSubnetCollection [-Credential <PSCredential>] [-Name] <String> [-Category] <ip_category>
 [-Subnets] <String[]> [[-Organization] <String>] [[-Tags] <String[]>] [-Quiet] [<CommonParameters>]
```

## DESCRIPTION
New-MCASSubnetCollection creates subnet collections in the MCAS tenant.

## EXAMPLES

### EXAMPLE 1
```
New-MCASSubnetCollection -Name 'Contoso Egress IPs' -Category Corporate -Subnets '1.1.1.1/32','2.2.2.2/32'
```

5a9e04c7f82b1bb8af51c7fb

### EXAMPLE 2
```
New-MCASSubnetCollection -Name 'Contoso Internal IPs' -Category Corporate -Subnets '10.0.0.0/8' -Quiet
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

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Category
{{Fill Category Description}}

```yaml
Type: ip_category
Parameter Sets: (All)
Aliases:
Accepted values: None, Corporate, Administrative, Risky, VPN, Cloud_Provider, Other

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Subnets
{{Fill Subnets Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Organization
{{Fill Organization Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tags
{{Fill Tags Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
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
