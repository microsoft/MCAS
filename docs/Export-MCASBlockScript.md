---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Export-MCASBlockScript

## SYNOPSIS
Exports a proxy or firewall block script for the unsanctioned apps in your Cloud App Security tenant.

## SYNTAX

```
Export-MCASBlockScript [-Credential <PSCredential>] [-DeviceType] <device_type> [<CommonParameters>]
```

## DESCRIPTION
Exports a block script, in the specified firewall or proxy device type format, for the unsanctioned apps.

'Export-MCASBlockScript -DeviceType \<device format\>' returns the text to be used in a Websense block script.
Methods available are only those available to custom objects by default.

## EXAMPLES

### EXAMPLE 1
```
Export-MCASBlockScript -DeviceType WEBSENSE
```

dest_host=lawyerstravel.com action=deny
dest_host=wellsfargo.com action=deny
dest_host=usbank.com action=deny
dest_host=care2.com action=deny
dest_host=careerbuilder.com action=deny
dest_host=abcnews.go.com action=deny
dest_host=accuweather.com action=deny
dest_host=zoovy.com action=deny
dest_host=cars.com action=deny

This pulls back string to be used as a block script in Websense format.

### EXAMPLE 2
```
Export-MCASBlockScript -DeviceType BLUECOAT_PROXYSG
```

url.domain=lawyerstravel.com deny
url.domain=wellsfargo.com deny
url.domain=usbank.com deny
url.domain=care2.com deny
url.domain=careerbuilder.com deny
url.domain=abcnews.go.com deny
url.domain=accuweather.com deny
url.domain=zoovy.com deny
url.domain=cars.com deny

This pulls back string to be used as a block script in BlueCoat format.

### EXAMPLE 3
```
Export-MCASBlockScript -DeviceType WEBSENSE | Set-Content MyWebsenseBlockScript.txt -Encoding UTF8
```

This pulls back a Websense block script in text string format and creates a new UTF-8 encoded text file out of it.

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

### -DeviceType
Specifies the device type to use for the format of the block script.
Possible Values: BLUECOAT_PROXYSG,CISCO_ASA,FORTINET_FORTIGATE,PALO_ALTO,JUNIPER_SRX,WEBSENSE,ZSCALER

```yaml
Type: device_type
Parameter Sets: (All)
Aliases: Appliance
Accepted values: BARRACUDA, BLUECOAT, CHECKPOINT, CISCO_ASA, CISCO_IRONPORT_PROXY, FORTIGATE, PALO_ALTO, SQUID, ZSCALER, MCAFEE_SWG, CISCO_SCAN_SAFE, JUNIPER_SRX, SOPHOS_SG, WEBSENSE_V7_5, WEBSENSE_SIEM_CEF, MACHINE_ZONE_MERAKI, SQUID_NATIVE, CISCO_FWSM, MICROSOFT_ISA_W3C, SONICWALL_SYSLOG, SOPHOS_CYBEROAM, CLAVISTER, JUNIPER_SSG, ZSCALER_QRADAR, JUNIPER_SRX_SD, JUNIPER_SRX_WELF, CISCO_ASA_FIREPOWER, GENERIC_CEF, GENERIC_LEEF, GENERIC_W3C, I_FILTER, CHECKPOINT_XML, CHECKPOINT_SMART_VIEW_TRACKER, BARRACUDA_NEXT_GEN_FW, BARRACUDA_NEXT_GEN_FW_WEBLOG

Required: True
Position: 1
Default value: None
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
