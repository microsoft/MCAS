<#

GENERAL CODING STANDARDS TO BE FOLLOWED IN THIS MODULE:

    https://github.com/PoshCode/PowerShellPracticeAndStyle

    and

    https://msdn.microsoft.com/en-us/library/dd878270%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396

#>


#----------------------------Configs-------------------------------
$appManifestFile = 'jpoeppel-PS-test-public-client.json'  # Config file for MSAL-based authentication to Azure Active Directory


#----------------------------Constants-----------------------------
$MCAS_TOKEN_VALIDATION_PATTERN = '^[0-9a-zA-Z-_=.+]{64,}$'

#----------------------------Enum Types----------------------------
enum mcas_app {
    Amazon_Web_Services = 11599
    Box = 10489
    Dropbox = 11627
    Google_Apps = 11770
    Microsoft_Azure = 12260
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
    BARRACUDA = 101                     # Barracuda - Web App Firewall (W3C)
    BARRACUDA_NEXT_GEN_FW = 191         # Barracude - F-Series Firewall
    BARRACUDA_NEXT_GEN_FW_WEBLOG = 193  # Barracude - F-Series Firewall Web Log Streaming
    BLUECOAT = 102                      # Blue Coat ProxySG - Access log (W3C)
    CHECKPOINT = 103                    # Check Point (CSV)
    CHECKPOINT_SMART_VIEW_TRACKER = 189 # Check Point - SmartView Tracker
    CHECKPOINT_XML = 187                # Check Point (XML)
    CISCO_ASA = 104                     # Cisco ASA Firewall
    CISCO_ASA_FIREPOWER = 177           # Cisco ASA FirePOWER
    CISCO_FWSM = 157                    # Cisco FWSM
    CISCO_IRONPORT_PROXY = 106          # CiscoIronPort WSA
    CISCO_SCAN_SAFE = 124               # Cisco ScanSafe
    CLAVISTER = 164                     # Clavister NGFW (Syslog)
    CUSTOM_PARSER = 167                 # Custom Parser
    FORCEPOINT = 202                    # Forcepoint Web Security Cloud
    FORTIGATE = 108                     # Fortinet Fortigate
    GENERIC_CEF = 179                   # Generic CEF log
    GENERIC_LEEF = 181                  # Generic LEEF log
    GENERIC_W3C = 183                   # Generic W3C log
    IBOSS = 200                         # Iboss Secure Cloud Gateway
    I_FILTER = 185                      # Digital Arts i-FILTER
    JUNIPER_SRX = 129                   # Juniper SRX
    JUNIPER_SRX_SD = 172                # Juniper SRX SD
    JUNIPER_SRX_WELF = 174              # Juniper SRX Welf
    JUNIPER_SSG = 168                   # Juniper SSG
    MACHINE_ZONE_MERAKI = 153           # Meraki - URLs log
    MCAFEE_SWG = 121                    # McAfee Web Gateway
    MICROSOFT_ISA_W3C = 159             # Microsoft Forefront Threat Management Gateway (W3C)
    PALO_ALTO = 112                     # PA Series Firewall
    # PALO_ALTO_SYSLOG not available here
    SONICWALL_SYSLOG = 160              # (Dell) SonicWALL
    SOPHOS_CYBEROAM = 162               # Sophos Cyberoam Web Filter and Firewall log
    SOPHOS_SG = 130                     # Sophos SG
    SOPHOS_XG = 198                     # Sophos XG
    SQUID = 114                         # Squid (Common)
    SQUID_NATIVE = 155                  # Squid (Native)
    WEBSENSE_SIEM_CEF = 138             # (WebSense) Web Security solutions - Internet Activity log (CEF)
    WEBSENSE_V7_5 = 135                 # (WebSense) Web Security solutions - Investigative detail report (CSV)
    ZSCALER = 120                       # Zscaler - Default CSV
    ZSCALER_QRADAR = 170                # Zscaler - QRadar LEEF
    ZSCALER_CEF = 196                   # Zscaler - CEF
}

enum ip_category {
    None = 0
    Corporate = 1
    Administrative = 2
    Risky = 3
    VPN = 4
    Cloud_Provider = 5
    Other = 6
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
    FULL_ACCESS = 0
    READ_ONLY = 1
    COMPLIANCE_READ_ONLY = 2
    #INSTANCE_ADMIN = 3
    #GROUP_ADMIN = 4
    #DISCOVERY_ADMIN = 5
}


#----------------------------Hash Tables---------------------------
$IPTagsList = [ordered]@{
    Akamai_Technologies                   = '0000002d0000000000000000'
    Amazon_Web_Services                   = '000000290000000000000000'
    Anonymous_proxy                       = '000000030000000000000000'
    Ascenty_Data_Centers                  = '0000002f0000000000000000'
    Botnet                                = '0000000c0000000000000000'
    Brute_force_attacker                  = '000000380000000000000000'
    Cisco_CWS                             = '000000270000000000000000'
    Cloud_App_Security_network            = '000000050000000000000000'
    Darknet_scanning_IP                   = '0000001f0000000000000000'
    Exchange_Online                       = '0000000e0000000000000000'
    Exchange_Online_Protection            = '000000150000000000000000'
    Google_Cloud_Platform                 = '000000280000000000000000'
    Internal_Network_IP                   = '000000310000000000000000'
    Malware_CnC_server                    = '0000000d0000000000000000'
    Masergy_Communications                = '0000002e0000000000000000'
    McAfee_Web_Gateway                    = '0000002c0000000000000000'
    Microsoft_Azure                       = '0000002a0000000000000000'
    Microsoft_Cloud                       = '0000001e0000000000000000'
    Microsoft_Hosting                     = '0000003a0000000000000000'
    Microsoft_authentication_and_identity = '000000100000000000000000'
    Office_365                            = '000000170000000000000000'
    Office_365_Planner                    = '000000190000000000000000'
    Office_365_ProPlus                    = '000000120000000000000000'
    Office_Online                         = '000000140000000000000000'
    Office_Sway                           = '0000001d0000000000000000'
    Office_Web_Access_Companion           = '0000001a0000000000000000'
    OneNote                               = '000000130000000000000000'
    Remote_Connectivity_Analyzer          = '0000001c0000000000000000'
    Salesforce_Cloud                      = '000000390000000000000000'
    Satellite_provider                    = '000000040000000000000000'
    ScanSafe                              = '000000300000000000000000'
    SharePoint_Online                     = '0000000f0000000000000000'
    Skype_for_Business_Online             = '000000180000000000000000'
    Symantec_Cloud                        = '000000330000000000000000'
    Tor                                   = '2dfa95cd7922d979d66fcff5'
    Yammer                                = '0000001b0000000000000000'
    Zscaler                               = '000000160000000000000000'
}

$UserAgentTagsList = [ordered]@{
    Native_client             = '000000000000000000000000'
    Outdated_browser          = '000000010000000000000000'
    Outdated_operating_system = '000000020000000000000000'
    Robot                     = '0000002b0000000000000000'
}

$ReportsList = @{
	'Activity by Location'                   = 'geolocation_summary'
    'Browser Use'                            = 'browser_usage'
    'IP Addresses'                           = 'ip_usage'
	'IP Addresses for Admins'                = 'ip_admin_usage'
	'OS Use'                                 = 'os_usage'
	'Strictly Remote Users'                  = 'standalone_users'
	'Cloud App Overview'                     = 'app_summary'
	'Inactive Accounts'                      = 'zombie_users'
	'Privileged Users'                       = 'admins'
	'Salesforce Special Privileged Accounts' = 'sf_permissions'
    'User Logon'                             = 'logins_rate'
	'Data Sharing Overview'                  = 'files_summary'
    'File Extensions'                        = 'file_extensions'
	'Orphan Files'                           = 'orphan_files'
    'Outbound Sharing by Domain'             = 'external_domains'
    'Owners of Shared Files'                 = 'shared_files_owners'
    'Personal User Accounts'                 = 'personal_users'
    'Sensitive File Names'                   = 'file_name_dlp'
}

# Create reversed copy of the reports list hash table (keys become values and values become keys)
$ReportsListReverse = @{}
$ReportsList.GetEnumerator() | ForEach-Object {
    $ReportsListReverse.Add($_.Value,$_.Key)
}

$GovernanceStatus = @{
    'Failed' = $false
    'Pending' = $null
    'Successful' = $true
}


#----------------------------Include functions---------------------------
# KUDOS to the chocolatey project for the basis of this code

# get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$ModulePath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)

# find and load all the ps1 files in the Functions subfolder
Resolve-Path -Path $ModulePath\Functions\*.ps1 | ForEach-Object -Process {
    . $_.ProviderPath
}


#----------------------------Exports---------------------------
# Cmdlets to export (must be exported as functions, not cmdlets) - This array format can be copied directly to the module manifest as the 'FunctionsToExport' value
$ExportedCommands = @(
    'Add-MCASAdminAccess',
    'Connect-MCAS',
    'ConvertFrom-MCASTimestamp',
    'Export-MCASBlockScript',
    'Export-MCASCredential',
    'Get-MCASAccount',
    'Get-MCASActivity',
    'Get-MCASActivityType',
    'Get-MCASAdminAccess',
    'Get-MCASAlert',
    'Get-MCASAppId',
    'Get-MCASAppInfo',
    'Get-MCASAppPermission',
    'Get-MCASConfiguration',
    'Get-MCASCredential',
    'Get-MCASDiscoveredApp',
    'Get-MCASDiscoveryDataSource',
    'Get-MCASDiscoverySampleLog',
    'Get-MCASFile',
    'Get-MCASGovernanceAction',
    'Get-MCASIPTag',
    'Get-MCASLogCollector',
    'Get-MCASPolicy',
    'Get-MCASPortalSettings',
    'Get-MCASRegionalUrl',
    'Get-MCASSiemAgent',
    'Get-MCASStream',
    'Get-MCASSubnetCollection',
    'Get-MCASUserGroup',
    'Import-MCASCredential',
    'Install-MCASSiemAgent',
    'New-MCASDiscoveryDataSource',
    'New-MCASSiemAgentToken',
    'New-MCASSubnetCollection',
    'Remove-MCASAdminAccess',
    'Remove-MCASDiscoveryDataSource',
    'Remove-MCASSubnetCollection',
    'Send-MCASDiscoveryLog',
    'Set-MCASAlert'
    )

    $ExportedCommands | ForEach-Object {
    Export-ModuleMember -Function $_
}

#Export-ModuleMember -Function Invoke-MCASRestMethod2

# Vars to export (must be exported here, even if also included in the module manifest in 'VariablesToExport'
Export-ModuleMember -Variable CASCredential

# Aliases to export
Export-ModuleMember -Alias *



<#
# Implement your module commands in this script.


# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function Get-MCASUserGroup


#>