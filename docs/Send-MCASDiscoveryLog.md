---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Send-MCASDiscoveryLog

## SYNOPSIS
Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.

## SYNTAX

```
Send-MCASDiscoveryLog [-Credential <PSCredential>] [-LogFile] <String> [-LogType] <device_type>
 [-DiscoveryDataSource] <String> [-UploadAsSnapshot] [-Delete] [<CommonParameters>]
```

## DESCRIPTION
Send-MCASDiscoveryLog uploads an edge device log file to be analyzed for SaaS discovery by Cloud App Security.

When using Send-MCASDiscoveryLog, you must provide a log file by name/path and a log file type, which represents the source firewall or proxy device type.
Also required is the name of the discovery data source with which the uploaded log should be associated; this can be created in the console.

Send-MCASDiscoveryLog does not return any value

## EXAMPLES

### EXAMPLE 1
```
Send-MCASDiscoveryLog -LogFile C:\Users\Alice\MyFirewallLog.log -LogType CISCO_IRONPORT_PROXY -DiscoveryDataSource 'My CAS Discovery Data Source'
```

This uploads the MyFirewallLog.log file to CAS for discovery, indicating that it is of the CISCO_IRONPORT_PROXY log format, and associates it with the data source name called 'My CAS Discovery Data Source'

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

### -LogFile
The full path of the Log File to be uploaded, such as 'C:\mylogfile.log'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -LogType
Specifies the source device type of the log file.

```yaml
Type: device_type
Parameter Sets: (All)
Aliases:
Accepted values: BARRACUDA, BLUECOAT, CHECKPOINT, CISCO_ASA, CISCO_IRONPORT_PROXY, FORTIGATE, PALO_ALTO, SQUID, ZSCALER, MCAFEE_SWG, CISCO_SCAN_SAFE, JUNIPER_SRX, SOPHOS_SG, WEBSENSE_V7_5, WEBSENSE_SIEM_CEF, MACHINE_ZONE_MERAKI, SQUID_NATIVE, CISCO_FWSM, MICROSOFT_ISA_W3C, SONICWALL_SYSLOG, SOPHOS_CYBEROAM, CLAVISTER, JUNIPER_SSG, ZSCALER_QRADAR, JUNIPER_SRX_SD, JUNIPER_SRX_WELF, CISCO_ASA_FIREPOWER, GENERIC_CEF, GENERIC_LEEF, GENERIC_W3C, I_FILTER, CHECKPOINT_XML, CHECKPOINT_SMART_VIEW_TRACKER, BARRACUDA_NEXT_GEN_FW, BARRACUDA_NEXT_GEN_FW_WEBLOG

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DiscoveryDataSource
Specifies the discovery data source name as reflected in your CAS console, such as 'US West Microsoft ASA'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UploadAsSnapshot
Specifies that the uploaded log file should be made into a snapshot report, in which case the value provided for -DiscoveryDataSource will become the snapshot report name.

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

### -Delete
Specifies that the uploaded log file should be deleted after the upload operation completes.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: dts

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
