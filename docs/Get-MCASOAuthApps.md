---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASOAuthApps

## SYNOPSIS
Get-MCASOAuthApps retrives OAuth Apps that were granted permission 

## SYNTAX

```
Get-MCASOAuthApps [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
This function retrives OAuth Apps that were granted permission 

## EXAMPLES

### EXAMPLE 1
```
Get-MCASOAuthApps
```
appStatus                : 0
communityUsage           : 1
appName                  : WD Antivirus Testground
isInternal               : False
firstInstalled           : 1553097013550
lastInstalled            : 1553097013550
actions                  : {@{is_blocking=True; uiGovernanceCategory=; display_
                           alert_text=TASKS_ADALIBPY_DISABLE_APP_DISPLAY_ALERT_
                           TEXT; bulk_support=; bulk_display_description=; 
                           confirmation_link=; display_title=TASKS_ADALIBPY_DIS
                           ABLE_APP_DISABLE_TITLE; display_description=; 
                           optional_notify=True; has_icon=True; display_alert_s
                           uccess_text=TASKS_ADALIBPY_DISABLE_APP_DISPLAY_ALERT
                           _SUCCESS_TEXT; governance_type=; 
                           preview_only=False; task_name=DisableAppTask; 
                           confirmation_button_text=; 
                           confirm_button_style=red; type=application; 
                           alert_display_title=}}
_tid                     : 92719368
userCount                : 1
userInstallationCount    : 1
severity                 : 1
saasId                   : 11161
localClientId            : 111111a1-2aaa-3333-cccc-4d444444d44d
instId                   : 0
o365AppType              : 0
homepage                 : https://demo.wd.microsoft.com
scopes                   : {@{category=N/A; description=View your basic 
                           profile info}, @{category=N/A; description=View 
                           your email address}, @{category=N/A; 
                           description=Sign you in and read your profile}}
description              : WD Antivirus Testground
shouldIgnoredInScoreCalc : True
isAdminConsent           : False
appId                    : 11161
snapshotLastModifiedDate : 2019-03-20T16:45:05.928Z
publisher                : Microsoft
scanTime                 : 1554310898349
instanceName             : Office 365
clientId                 : aa1111a1-bbb2-3c33-d4dd-5ee5ee443333
_id                      : 5c811382503a8eab728e03a3


Retrieves all the OAuth Apps that were granted permission


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
### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
