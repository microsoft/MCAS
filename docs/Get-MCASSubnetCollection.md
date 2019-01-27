---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASSubnetCollection

## SYNOPSIS
Lists the subnet collections that are defined in MCAS for enrichment of IP address information.

## SYNTAX

```
Get-MCASSubnetCollection [-Credential <PSCredential>] [-ResultSetSize <Int32>] [-Skip <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-MCASSubnetCollection gets subnet collections defined in the MCAS tenant.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASSubnetCollection
```

category     : 1
subnets      : {@{originalString=10.0.0.0/8; mask=104; address=0000:0000:0000:0000:0000:ffff:0a00:0000}}
name         : Contoso Internal IPs
tags         : {}
location     :
_tid         : 26034820
organization :
_id          : 5a9e053df82b1bb8af51c802
Identity     : 5a9e053df82b1bb8af51c802

category     : 1
subnets      : {@{originalString=1.1.1.1/32; mask=128; address=0000:0000:0000:0000:0000:ffff:0101:0101},
            @{originalString=2.2.2.2/32; mask=128; address=0000:0000:0000:0000:0000:ffff:0202:0202}}
name         : Contoso Egress IPs
tags         : {}
location     :
_tid         : 26034820
organization :
_id          : 5a9e04c7f82b1bb8af51c7fb
Identity     : 5a9e04c7f82b1bb8af51c7fb

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

### -ResultSetSize
Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
Specifies the number of records, from the beginning of the result set, to skip.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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
