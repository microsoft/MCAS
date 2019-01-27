---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASDiscoverySampleLog

## SYNOPSIS
Retrieves one or more sample discovery logs in a specified .

## SYNTAX

```
Get-MCASDiscoverySampleLog [-DeviceType] <device_type> [-Quiet] [<CommonParameters>]
```

## DESCRIPTION
Get-MCASDiscoverySampleLog gets the sample log files that are available for the specified device type.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASDiscoverySampleLog
```

C:\\\>Get-MCASDiscoverySampleLog -DeviceType CHECKPOINT

C:\Users\alice\check-point_demo_log\check-point-2_demo_log.log
C:\Users\alice\check-point_demo_log\check-point_demo_log.log

## PARAMETERS

### -DeviceType
Specifies which device type for which a sample log file should be downloaded

```yaml
Type: device_type
Parameter Sets: (All)
Aliases:
Accepted values: BARRACUDA, BLUECOAT, CHECKPOINT, CISCO_ASA, CISCO_IRONPORT_PROXY, FORTIGATE, PALO_ALTO, SQUID, ZSCALER, MCAFEE_SWG, CISCO_SCAN_SAFE, JUNIPER_SRX, SOPHOS_SG, WEBSENSE_V7_5, WEBSENSE_SIEM_CEF, MACHINE_ZONE_MERAKI, SQUID_NATIVE, CISCO_FWSM, MICROSOFT_ISA_W3C, SONICWALL_SYSLOG, SOPHOS_CYBEROAM, CLAVISTER, JUNIPER_SSG, ZSCALER_QRADAR, JUNIPER_SRX_SD, JUNIPER_SRX_WELF, CISCO_ASA_FIREPOWER, GENERIC_CEF, GENERIC_LEEF, GENERIC_W3C, I_FILTER, CHECKPOINT_XML, CHECKPOINT_SMART_VIEW_TRACKER, BARRACUDA_NEXT_GEN_FW, BARRACUDA_NEXT_GEN_FW_WEBLOG

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Quiet
Specifies to not output the file names

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
