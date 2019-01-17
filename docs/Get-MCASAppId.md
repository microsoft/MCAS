---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASAppId

## SYNOPSIS
Returns an application's id (integer) given its name.

## SYNTAX

```
Get-MCASAppId [-AppName] <mcas_app> [<CommonParameters>]
```

## DESCRIPTION
Get-MCASAppId gets the unique identifier integer value that represents an app in MCAS.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASAppId -AppName Microsoft_Cloud_App_Security
```

20595

## PARAMETERS

### -AppName
Specifies the app for which to retrieve the integer id value.

```yaml
Type: mcas_app
Parameter Sets: (All)
Aliases:
Accepted values: Box, Okta, Salesforce, Office_365, Microsoft_Yammer, Amazon_Web_Services, Dropbox, Google_Apps, ServiceNow, Microsoft_OneDrive_for_Business, Microsoft_Cloud_App_Security, Microsoft_Sharepoint_Online, Microsoft_Exchange_Online, Microsoft_Skype_for_Business, Microsoft_Power_BI, Microsoft_Teams

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
