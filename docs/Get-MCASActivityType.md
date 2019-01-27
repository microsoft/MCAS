---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASActivityType

## SYNOPSIS
Lists the activity types that MCAS is aware of for a given application.

## SYNTAX

```
Get-MCASActivityType [-Credential <PSCredential>] [-AppId] <Int32> [-ResultSetSize <Int32>] [-Skip <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-MCASActivityType lists the activity types that MCAS consumes for the specified app.
MCAS activities can be filtered by these types allowing for granular policies to watch for very specific activity.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASActivityType -AppId 20595
```

name                                                                               app types
----                                                                               --- -----
Accept file access request                                Microsoft_Cloud_App_Security {2424867}
Add item to list                                          Microsoft_Cloud_App_Security {2424861}
Add parent folder to file                                 Microsoft_Cloud_App_Security {917585}
Add privilege                                             Microsoft_Cloud_App_Security {2424833}
Apply Azure Information Protection classification labels  Microsoft_Cloud_App_Security {917663}
Assign tag                                                Microsoft_Cloud_App_Security {917596}
Block app                                                 Microsoft_Cloud_App_Security {917622, 917668}
Certificate upload                                        Microsoft_Cloud_App_Security {917621}
Change OAuth token                                        Microsoft_Cloud_App_Security {917526}
Change SAML certificate                                   Microsoft_Cloud_App_Security {917528}
Change password                                           Microsoft_Cloud_App_Security {2424864, 917507}
Copy item                                                 Microsoft_Cloud_App_Security {2424834}
Create API token                                          Microsoft_Cloud_App_Security {917513}
Create Cloud Discovery anomaly policy                     Microsoft_Cloud_App_Security {917633}
Create Cloud Discovery policy                             Microsoft_Cloud_App_Security {917626}
Create IP address range                                   Microsoft_Cloud_App_Security {917590}
Create activity policy                                    Microsoft_Cloud_App_Security {917549}
Create anomaly detection policy                           Microsoft_Cloud_App_Security {917606}
Create file policy                                        Microsoft_Cloud_App_Security {917567}
Create inline policy                                      Microsoft_Cloud_App_Security {917573}
Create item                                               Microsoft_Cloud_App_Security {2424835}
Create ownership notification                             Microsoft_Cloud_App_Security {917578}
Create tag                                                Microsoft_Cloud_App_Security {917593}
Create user                                               Microsoft_Cloud_App_Security {917516}
DLP match detected                                        Microsoft_Cloud_App_Security {2424863}
Delete Cloud Discovery anomaly policy                     Microsoft_Cloud_App_Security {917635}
Delete Cloud Discovery data                               Microsoft_Cloud_App_Security {917643}
Delete Cloud Discovery policy                             Microsoft_Cloud_App_Security {917628}
Delete IP address range                                   Microsoft_Cloud_App_Security {917592}
Delete activity policy                                    Microsoft_Cloud_App_Security {917551}
Delete anomaly detection policy                           Microsoft_Cloud_App_Security {917608}
Delete file policy                                        Microsoft_Cloud_App_Security {917569}
Delete inline policy                                      Microsoft_Cloud_App_Security {917575}
Delete item                                               Microsoft_Cloud_App_Security {2424836}
Delete ownership notification                             Microsoft_Cloud_App_Security {917580}
Delete report                                             Microsoft_Cloud_App_Security {917648}
Delete tag                                                Microsoft_Cloud_App_Security {917595}
Delete user                                               Microsoft_Cloud_App_Security {917517}
Deny file access request                                  Microsoft_Cloud_App_Security {2424868}
Deploy app                                                Microsoft_Cloud_App_Security {917640, 917641, 917642}
Disable policy                                            Microsoft_Cloud_App_Security {917605}
Dismiss alert                                             Microsoft_Cloud_App_Security {917544}
Dismiss alerts - bulk                                     Microsoft_Cloud_App_Security {917625}
Download file                                             Microsoft_Cloud_App_Security {196354}
Download item                                             Microsoft_Cloud_App_Security {2424837}
Edit Cloud Discovery anomaly policy                       Microsoft_Cloud_App_Security {917634}
Edit Cloud Discovery policy                               Microsoft_Cloud_App_Security {917627}
Edit IP address range                                     Microsoft_Cloud_App_Security {917591}
Edit activity policy                                      Microsoft_Cloud_App_Security {917550}
Edit anomaly detection policy                             Microsoft_Cloud_App_Security {917607}
Edit file policy                                          Microsoft_Cloud_App_Security {917568}
Edit inline policy                                        Microsoft_Cloud_App_Security {917574}
Edit item                                                 Microsoft_Cloud_App_Security {2424838}
Edit ownership notification                               Microsoft_Cloud_App_Security {917579}
Edit permissions                                          Microsoft_Cloud_App_Security {917657}
Edit tag                                                  Microsoft_Cloud_App_Security {917594}
Editors can share                                         Microsoft_Cloud_App_Security {917572, 917577}
Enable policy                                             Microsoft_Cloud_App_Security {917604}
Failed log on                                             Microsoft_Cloud_App_Security {2424839, 917506}
Generate report                                           Microsoft_Cloud_App_Security {917646, 917645}
Generate traffic log report                               Microsoft_Cloud_App_Security {917673}
Grant owner permission                                    Microsoft_Cloud_App_Security {917563}
Grant read permission                                     Microsoft_Cloud_App_Security {917558, 917559}
Grant write permission                                    Microsoft_Cloud_App_Security {917562}
Log on                                                    Microsoft_Cloud_App_Security {196355, 2424840, 196352, 917..
Log out                                                   Microsoft_Cloud_App_Security {1028, 917505, 2424841}
Make file private                                         Microsoft_Cloud_App_Security {917531, 917510}
Mark app                                                  Microsoft_Cloud_App_Security {917666, 917667, 917603, 917602
Modify managed domains                                    Microsoft_Cloud_App_Security {917617}
Move item                                                 Microsoft_Cloud_App_Security {2424842}
Notify user on application access token                   Microsoft_Cloud_App_Security {917582}
Open via public link                                      Microsoft_Cloud_App_Security {917638}
Override risk score                                       Microsoft_Cloud_App_Security {917670}
Owners can share                                          Microsoft_Cloud_App_Security {917571, 917576}
Print asset                                               Microsoft_Cloud_App_Security {2424843}
Quarantine file                                           Microsoft_Cloud_App_Security {917649, 917536, 917619}
Reduce public permissions                                 Microsoft_Cloud_App_Security {917676, 917678}
Remove Azure Information Protection classification labels Microsoft_Cloud_App_Security {917664}
Remove direct share link                                  Microsoft_Cloud_App_Security {917541, 917542}
Remove external permissions                               Microsoft_Cloud_App_Security {917511, 917530}
Remove file from folder                                   Microsoft_Cloud_App_Security {917586}
Remove permission                                         Microsoft_Cloud_App_Security {917588}
Remove privilege                                          Microsoft_Cloud_App_Security {2424856}
Remove public permissions                                 Microsoft_Cloud_App_Security {917512, 917529}
Remove user's collaborations                              Microsoft_Cloud_App_Security {917548, 917547}
Rename item                                               Microsoft_Cloud_App_Security {2424845}
Require user to sign in again                             Microsoft_Cloud_App_Security {917665}
Reset password                                            Microsoft_Cloud_App_Security {2424851, 2424846, 917615, 91..
Resolve alert                                             Microsoft_Cloud_App_Security {917543}
Resolve alerts - bulk                                     Microsoft_Cloud_App_Security {917651, 917652}
Restore file from quarantine                              Microsoft_Cloud_App_Security {917620, 917650}
Restore item                                              Microsoft_Cloud_App_Security {2424847}
Revoke API token                                          Microsoft_Cloud_App_Security {917514}
Revoke admin privilege                                    Microsoft_Cloud_App_Security {917552, 917553}
Revoke application access token                           Microsoft_Cloud_App_Security {917554, 917555, 917636, 917637
Revoke owner permission                                   Microsoft_Cloud_App_Security {917565}
Revoke password                                           Microsoft_Cloud_App_Security {917535}
Revoke read permission                                    Microsoft_Cloud_App_Security {917560, 917561}
Revoke user password                                      Microsoft_Cloud_App_Security {917525}
Revoke write permission                                   Microsoft_Cloud_App_Security {917564}
Run command                                               Microsoft_Cloud_App_Security {2424848}
Run ownership notification                                Microsoft_Cloud_App_Security {917581}
SIEM agents                                               Microsoft_Cloud_App_Security {917658, 917659, 917660, 917661
Scan on-demand                                            Microsoft_Cloud_App_Security {917618}
Search document                                           Microsoft_Cloud_App_Security {2424849}
Set app-permission status                                 Microsoft_Cloud_App_Security {917653, 917656, 917654, 917655
Share item                                                Microsoft_Cloud_App_Security {2424853}
Single sign-on log on                                     Microsoft_Cloud_App_Security {1024}
Suspend user                                              Microsoft_Cloud_App_Security {917533, 917523}
Sync item                                                 Microsoft_Cloud_App_Security {2424854}
Test API                                                  Microsoft_Cloud_App_Security {917584}
Transfer document ownership                               Microsoft_Cloud_App_Security {917546, 917532, 917545, 917570
Trash item                                                Microsoft_Cloud_App_Security {2424855}
Unassign tag                                              Microsoft_Cloud_App_Security {917597}
Unblock app                                               Microsoft_Cloud_App_Security {917669, 917623}
Unshare item                                              Microsoft_Cloud_App_Security {2424857}
Unspecified                                               Microsoft_Cloud_App_Security {2424870, 2424832}
Unsuspend user                                            Microsoft_Cloud_App_Security {917534, 917524}
Update Cloud Discovery service                            Microsoft_Cloud_App_Security {917675, 917672, 917671, 917674
Update file sharing invitation                            Microsoft_Cloud_App_Security {2424858}
Update user                                               Microsoft_Cloud_App_Security {917519, 917518}
Upload Cloud Discovery file                               Microsoft_Cloud_App_Security {917601}
Upload file                                               Microsoft_Cloud_App_Security {196353}
Upload item                                               Microsoft_Cloud_App_Security {2424859}
View item                                                 Microsoft_Cloud_App_Security {2424860}

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

### -AppId
Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Service, Services

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
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
