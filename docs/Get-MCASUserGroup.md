---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASUserGroup

## SYNOPSIS
Retrieves groups that are available for use in MCAS filters and policies.

## SYNTAX

```
Get-MCASUserGroup [[-Credential] <PSCredential>] [[-ResultSetSize] <Int32>] [[-Skip] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-MCASUserGroup gets groups that are available for use in MCAS filters and policies.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASUserGroup
```

PS C:\\\> Get-MCASUserGroup

 status                     : 0
 lastUpdatedTimestamp       : 1506613547015
 name                       : Office 365 administrator
 nameTemplate               : @{parameters=; template=SAGE_ADMIN_USERS_TAGS_GENERATOR_QUERY_BASED_USER_TAG_NAME}
 description                : Company administrators, user account administrators, helpdesk administrators, service
                             support administrators, and billing administrators
 descriptionTemplate        : @{template=SAGE_ADMIN_USERS_TAGS_GENERATOR_O365_DESCRIPTION}
 visibility                 : 0
 usersCount                 : 1
 source                     : @{addCondition=; removeCondition=; type=2; appId=11161}
 successfullyImportedBySage : True
 _tid                       : 26034820
 appId                      : 11161
 lastScannedBySage          : 1511881457181
 generatorType              : 0
 _id                        : 59cd1847321708f4acbe8c1f
 type                       : 2
 id                         : 59cd1847321708f4acbe8c1e
 target                     : 0

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

### -ResultSetSize
Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
