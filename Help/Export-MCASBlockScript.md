---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Export-MCASBlockScript

## SYNOPSIS
Exports a proxy or firewall block script for the unsanctioned apps in your Cloud App Security tenant.

## SYNTAX

```
Export-MCASBlockScript [-TenantUri <String>] [-Credential <PSCredential>] [-Appliance] <blockscript_format>
```

## DESCRIPTION
Exports a block script, in the specified firewall or proxy device type format, for the unsanctioned apps.

'Export-MCASBlockScript -Appliance \<device format\>' returns the text to be used in a Websense block script.
Methods available are only those available to custom objects by default.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Export-MCASBlockScript -Appliance WEBSENSE
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

### -------------------------- EXAMPLE 2 --------------------------
```
Export-MCASBlockScript -Appliance BLUECOAT_PROXYSG
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

### -------------------------- EXAMPLE 3 --------------------------
```
Export-MCASBlockScript -Appliance WEBSENSE | Set-Content MyWebsenseBlockScript.txt -Encoding UTF8
```

This pulls back a Websense block script in text string format and creates a new UTF-8 encoded text file out of it.

## PARAMETERS

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

### -Appliance
Specifies the appliance type to use for the format of the block script.
Possible Values: BLUECOAT_PROXYSG, CISCO_ASA, FORTINET_FORTIGATE, PALO_ALTO, JUNIPER_SRX, WEBSENSE

```yaml
Type: blockscript_format
Parameter Sets: (All)
Aliases: 
Accepted values: BLUECOAT_PROXYSG, CISCO_ASA, FORTINET_FORTIGATE, PALO_ALTO, ZSCALER, JUNIPER_SRX, WEBSENSE

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

