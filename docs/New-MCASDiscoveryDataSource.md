---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# New-MCASDiscoveryDataSource

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
New-MCASDiscoveryDataSource [[-Credential] <PSCredential>] [-Name] <String> [-DeviceType] <device_type>
 [-ReceiverType] <String> [-AnonymizeUsers] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AnonymizeUsers
{{Fill AnonymizeUsers Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
{{Fill Credential Description}}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceType
{{Fill DeviceType Description}}

```yaml
Type: device_type
Parameter Sets: (All)
Aliases:
Accepted values: BARRACUDA, BLUECOAT, CHECKPOINT, CISCO_ASA, CISCO_IRONPORT_PROXY, FORTIGATE, PALO_ALTO, SQUID, ZSCALER, MCAFEE_SWG, CISCO_SCAN_SAFE, JUNIPER_SRX, SOPHOS_SG, WEBSENSE_V7_5, WEBSENSE_SIEM_CEF, MACHINE_ZONE_MERAKI, SQUID_NATIVE, CISCO_FWSM, MICROSOFT_ISA_W3C, SONICWALL_SYSLOG, SOPHOS_CYBEROAM, CLAVISTER, JUNIPER_SSG, ZSCALER_QRADAR, JUNIPER_SRX_SD, JUNIPER_SRX_WELF, CISCO_ASA_FIREPOWER, GENERIC_CEF, GENERIC_LEEF, GENERIC_W3C, I_FILTER, CHECKPOINT_XML, CHECKPOINT_SMART_VIEW_TRACKER, BARRACUDA_NEXT_GEN_FW, BARRACUDA_NEXT_GEN_FW_WEBLOG

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReceiverType
{{Fill ReceiverType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: FTP, FTPS, Syslog-UDP, Syslog-TCP, Syslog-TLS

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
