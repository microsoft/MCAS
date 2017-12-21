---
external help file: Cloud-App-Security-help.xml
Module Name: Cloud-App-Security
online version: 
schema: 2.0.0
---

# Send-MCASDiscoveryLog

## SYNOPSIS
Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.

## SYNTAX

```
Send-MCASDiscoveryLog [-LogFile] <String> [-LogType] <device_type> [-DiscoveryDataSource] <String> [-Delete]
 [-TenantUri <String>] [-Credential <PSCredential>]
```

## DESCRIPTION
Send-MCASDiscoveryLog uploads an edge device log file to be analyzed for SaaS discovery by Cloud App Security.

When using Send-MCASDiscoveryLog, you must provide a log file by name/path and a log file type, which represents the source firewall or proxy device type.
Also required is the name of the discovery data source with which the uploaded log should be associated; this can be created in the console.

Send-MCASDiscoveryLog does not return any value

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Send-MCASDiscoveryLog -LogFile C:\Users\Alice\MyFirewallLog.log -LogType CISCO_IRONPORT_PROXY -DiscoveryDataSource 'My CAS Discovery Data Source'
```

This uploads the MyFirewallLog.log file to CAS for discovery, indicating that it is of the CISCO_IRONPORT_PROXY log format, and associates it with the data source name called 'My CAS Discovery Data Source'

## PARAMETERS

### -LogFile
The full path of the Log File to be uploaded, such as 'C:\mylogfile.log'.

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

### -LogType
Specifies the source device type of the log file.

```yaml
Type: device_type
Parameter Sets: (All)
Aliases: 
Accepted values: BARRACUDA, BLUECOAT, CHECKPOINT, CISCO_ASA, CISCO_IRONPORT_PROXY, CISCO_FWSM, CISCO_SCAN_SAFE, CLAVISTER, FORTIGATE, JUNIPER_SRX, MACHINE_ZONE_MERAKI, MCAFEE_SWG, MICROSOFT_ISA_W3C, PALO_ALTO, PALO_ALTO_SYSLOG, SONICWALL_SYSLOG, SOPHOS_CYBEROAM, SOPHOS_SG, SQUID, SQUID_NATIVE, WEBSENSE_SIEM_CEF, WEBSENSE_V7_5, ZSCALER

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

