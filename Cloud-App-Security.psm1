#----------------------------Include functions---------------------------
# KUDOS to the chocolatey project for the basis of this code

# get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)

#find all the ps1 files in the subfolder functions
Resolve-Path -Path $mypath\functions\*.ps1 | ForEach-Object -Process {
    . $_.ProviderPath
    $Function = ((Split-Path -Path $_.ProviderPath -Leaf).Split('.')[0])   
}


#----------------------------Exports---------------------------
# Cmdlets to export (must be exported as functions, not cmdlets)

$ExportedCommands = @('Add-MCASAdminAccess','Export-MCASBlockScript','Get-MCASAdminAccess','Get-MCASAccount','Get-MCASActivity','Get-MCASAlert','Get-MCASAppInfo','Get-MCASCredential','Get-MCASDiscoveredApp','Get-MCASFile','Get-MCASGovernanceLog','Get-MCASReport','Get-MCASStream','Remove-MCASAdminAccess','Send-MCASDiscoveryLog','Set-MCASAlert')

$ExportedCommands | ForEach-Object {Export-ModuleMember -Function $_}

Export-ModuleMember -Function Invoke-MCASRestMethod


# Vars to export (must be exported here, even if also included in the module manifest in 'VariablesToExport'
Export-ModuleMember -Variable CASCredential

# Aliases to export
Export-ModuleMember -Alias *


#----------------------------Constants----------------------------
#Set-Variable MaxResultSize -Option Constant -Value 100


#----------------------------Enum Types----------------------------
enum mcas_app {
    Amazon_Web_Services = 11599
    Box = 10489
    Dropbox = 11627
    Google_Apps = 11770
    Microsoft_OneDrive_for_Business = 15600
    Microsoft_Cloud_App_Security = 20595
    Microsoft_Sharepoint_Online = 20892
    Microsoft_Skype_for_Business = 25275
    Microsoft_Exchange_Online = 20893
    Microsoft_Teams = 28375
    Microsoft_Yammer = 11522
    Microsoft_Power_BI = 26324
    Office_365 = 11161
    Okta = 10980
    Salesforce = 11114
    ServiceNow = 14509
    }

enum device_type {
    BARRACUDA
    BLUECOAT
    CHECKPOINT
    CISCO_ASA
    CISCO_IRONPORT_PROXY
    CISCO_FWSM
    CISCO_SCAN_SAFE
    CLAVISTER
    FORTIGATE
    JUNIPER_SRX
    MACHINE_ZONE_MERAKI
    MCAFEE_SWG
    MICROSOFT_ISA_W3C
    PALO_ALTO
    PALO_ALTO_SYSLOG
    SONICWALL_SYSLOG
    SOPHOS_CYBEROAM
    SOPHOS_SG
    SQUID
    SQUID_NATIVE
    WEBSENSE_SIEM_CEF
    WEBSENSE_V7_5
    ZSCALER
    }

enum blockscript_format {
    BLUECOAT_PROXYSG = 102
    CISCO_ASA = 104
    FORTINET_FORTIGATE = 108
    PALO_ALTO = 112
    JUNIPER_SRX = 129
    WEBSENSE = 135
    ZSCALER = 120
    }

enum ip_category {
    None = 0
    Internal = 1
    Administrative = 2
    Risky = 3
    VPN = 4
    Cloud_Provider = 5
    }

enum severity_level {
    High = 2
    Medium = 1
    Low = 0
    }

enum resolution_status {
    Resolved = 2
    Dismissed = 1
    Open = 0
    }

enum file_type {
    Other = 0
    Document = 1
    Spreadsheet = 2
    Presentation = 3
    Text = 4
    Image = 5
    Folder = 6
    }

enum file_access_level {
    Private = 0
    Internal = 1
    External = 2
    Public = 3
    PublicInternet = 4
    }

enum app_category {
    ACCOUNTING_AND_FINANCE
    ADVERTISING
    BUSINESS_MANAGEMENT
    CLOUD_STORAGE
    CODE_HOSTING
    COLLABORATION
    COMMUNICATIONS
    CONTENT_MANAGEMENT
    CONTENT_SHARING
    CRM
    CUSTOMER_SUPPORT
    DATA_ANALYTICS
    DEVELOPMENT_TOOLS
    ECOMMERCE
    EDUCATION
    FORUMS
    HEALTH
    HOSTING_SERVICES
    HUMAN_RESOURCE_MANAGEMENT
    IT_SERVICES
    MARKETING
    MEDIA
    NEWS_AND_ENTERTAINMENT
    ONLINE_MEETINGS
    OPERATIONS_MANAGEMENT
    PRODUCT_DESIGN
    PRODUCTIVITY
    PROJECT_MANAGEMENT
    PROPERTY_MANAGEMENT
    SALES
    SECURITY
    SOCIAL_NETWORK
    SUPLLY_CHAIN_AND_LOGISTICS
    TRANSPORTATION_AND_TRAVEL
    VENDOR_MANAGEMENT_SYSTEM
    WEB_ANALYTICS
    WEBMAIL
    WEBSITE_MONITORING
    }

enum permission_type {
    READ_ONLY
    FULL_ACCESS
    }

<#
enum alert_type
    {
    ALERT_ADMIN_USER = 14680070
    ALERT_CABINET_EVENT_MATCH_AUDIT = 15728641
    ALERT_CABINET_EVENT_MATCH_FILE = 15728642
    ALERT_GEOLOCATION_NEW_COUNTRY = 196608
    ALERT_MANAGEMENT_DISCONNECTED_API = 15794945
    ALERT_SUSPICIOUS_ACTIVITY = 14680083
    ALERT_COMPROMISED_ACCOUNT =
    ALERT_DISCOVERY_ANOMALY_DETECTION =
    ALERT_CABINET_INLINE_EVENT_MATCH =
    ALERT_CABINET_EVENT_MATCH_OBJECT =
    ALERT_CABINET_DISCOVERY_NEW_SERVICE =
    ALERT_NEW_ADMIN_LOCATION =
    ALERT_PERSONAL_USER_SAGE =
    ALERT_ZOMBIE_USER =
    }
#>


#----------------------------Hash Tables---------------------------
$IPTagsList = @{
    Anonymous_Proxy = '000000030000000000000000'
    Botnet = '0000000c0000000000000000'
    Darknet_Scanning_IP = '0000001f0000000000000000'
    Exchange_Online = '0000000e0000000000000000'
    Exchange_Online_Protection = '000000150000000000000000'
    Malware_CnC_Server = '0000000d0000000000000000'
    Microsoft_Cloud = '0000001e0000000000000000'
    Microsoft_Authentication_and_Identity = '000000100000000000000000'
    Office_365 = '000000170000000000000000'
    Office_365_Planner = '000000190000000000000000'
    Office_365_ProPlus = '000000120000000000000000'
    Office_Online = '000000140000000000000000'
    Office_Sway = '0000001d0000000000000000'
    Office_Web_Access_Companion = '0000001a0000000000000000'
    OneNote = '000000130000000000000000'
    Remote_Connectivity_Analyzer = '0000001c0000000000000000'
    Satellite_Provider = '000000040000000000000000'
    SharePoint_Online = '0000000f0000000000000000'
    Skype_for_Business_Online = '000000180000000000000000'
    Smart_Proxy_and_Access_Proxy_Network = '000000050000000000000000'
    Tor = '2dfa95cd7922d979d66fcff5'
    Yammer = '0000001b0000000000000000'
    Zscaler = '000000160000000000000000'
    }

$ReportsList = @{
	'Activity by Location' = 'geolocation_summary/'
	'Browser Use' = 'browser_usage/'
	'IP Addresses' = 'ip_usage/'
	'IP Addresses for Admins' = 'ip_admin_usage/'
	'OS Use' = 'os_usage/'
	'Strictly Remote Users' = 'standalone_users/'
	'Cloud App Overview' = 'app_summary/'
	'Inactive Accounts' = 'zombie_users/'
	'Privileged Users' = 'admins/'
	'Salesforce Special Privileged Accounts' = 'sf_permissions/'
	'User Logon' = 'logins_rate/'
	'Data Sharing Overview' = 'files_summary/'
	'File Extensions' = 'file_extensions/'
	'Orphan Files' = 'orphan_files/'
	'Outbound Sharing by Domain' = 'external_domains/'
	'Owners of Shared Files' = 'shared_files_owners/'
	'Personal User Accounts' = 'personal_users/'
	'Sensitive File Names' = 'file_name_dlp/'
}

$GovernanceStatus = @{
    'Failed' = $false
    'Pending' = $null
    'Successful' = $true
}




