---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASConfiguration

## SYNOPSIS
Retrieves MCAS configuration settings.

## SYNTAX

```
Get-MCASConfiguration [-Credential <PSCredential>] [[-Settings] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get-MCASConfiguration lists the settings, of the specified type, of the MCAS tenant.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASConfiguration
```

environmentName            : Contoso
omsWorkspaces              :
quarantineSite             :
ssoNewSPEntityId           : https://contoso.portal.cloudappsecurity.com/saml/consumer
ssoSPEntityId              : https://contoso.portal.cloudappsecurity.com/saml/consumer
emailMaskPolicyOptions     : @{FULL_CONTENT=CONSOLE_GENERAL_SETTINGS_EMAIL_MASK_POLICIES_NAME_FULL_CONTENT;
                            MASKED_SUBJECT=CONSOLE_GENERAL_SETTINGS_EMAIL_MASK_POLICIES_NAME_MASKED_SUBJECT;
                            ONLY_ID=CONSOLE_GENERAL_SETTINGS_EMAIL_MASK_POLICIES_NAME_ONLY_ID}
ssoEntityId                :
ssoCertificate             :
ssoHasMetadata             : True
ssoEnabled                 : False
allowAzIP                  : True
ssoSignInPageUrl           :
canChangeAllowAzIP         : True
quarantineUserNotification : This file was quarantined because it might conflict with your organization's security and
                            compliance policies.
Contact your IT administrator for more information.
ssoSignOutPageUrl          :
languageData               : @{tenantLanguage=default; availableLanguages=System.Object\[\]}
discoveryMasterTimeZone    : Etc/GMT
ssoOldSPEntityId           : https://us.portal.cloudappsecurity.com/saml/consumer?tenant_id=26034820
ssoByDomain                : True
ignoreExternalAzIP         : False
ssoLockdown                : False
ssoSPLogoutId              : https://contoso.portal.cloudappsecurity.com/saml/logout
ssoSignAssertion           : False
showAllowAzIP              : True
emailMaskPolicy            : MASKED_SUBJECT
orgDisplayName             : Contoso
domains                    : {contoso.onmicrosoft.com}
showSuffixDisclaimer       : True
logoFilePath               :

### EXAMPLE 2
```
Get-MCASConfiguration -Settings Mail
```

fromDisplayName replyTo from                                 htmlTemplate
--------------- ------- ----                                 ------------
ContosoSecurity         security@contoso.com

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

### -Settings
Specifies which setting types to list.
Possible Values: 'General'(default),'Mail','ScoreMetrics','SnapshotReports','ContinuousReports','AppTags','UserEnrichment','Anonymization','InfoProtection','ManagedDevices'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: General
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
