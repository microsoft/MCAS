<#
.Synopsis
   Retrieves one or more sample discovery logs in a specified .
.DESCRIPTION
   Get-MCASDiscoverySampleLog gets the sample log files that are available for the specified device type.

.EXAMPLE
    PS C:\> Get-MCASDiscoverySampleLog

    C:\>Get-MCASDiscoverySampleLog -DeviceType CHECKPOINT

    C:\Users\alice\check-point_demo_log\check-point-2_demo_log.log
    C:\Users\alice\check-point_demo_log\check-point_demo_log.log

.FUNCTIONALITY
   Get-MCASDiscoverySampleLog is intended to download the sample log files that are available for the specified device type. It downloads these as compressed zip files,
   then extracts the text log files from the zip files to a newly created subdirectory of the current. It returns the full path to each sample log it extracts, unless
   the -Quiet switch is specified, in which case it returns nothing.
   
#>
function Get-MCASDiscoverySampleLog {
    [CmdletBinding()]
    param
    (
        # Specifies which device type for which a sample log file should be downloaded
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [device_type]$DeviceType,

        # Specifies to not output the file names
        [switch]$Quiet
    )
    begin {
        Write-Verbose "Attempting to load assembly [system.io.compression.filesystem]"
        Add-Type -assembly "system.io.compression.filesystem"
    }
    process {

        # Select the sample log file to download based on the specified device type
        Write-Verbose "Device type specified was $DeviceType"
        switch ($DeviceType) {
            'BARRACUDA'                     {$fileName = 'barracuda-web-app-firewall-w3c_demo_log.log'}
            'BARRACUDA_NEXT_GEN_FW'         {$fileName = 'barracuda-f-series-firewall_demo_log.log'}
            'BARRACUDA_NEXT_GEN_FW_WEBLOG'  {$fileName = 'barracuda-f-series-firewall-web-log-streaming_demo_log.log'}
            'BLUECOAT'                      {$fileName = 'blue-coat-proxysg-access-log-w3c_demo_log.log'}
            'CHECKPOINT'                    {$fileName = 'check-point_demo_log.log'}
            'CHECKPOINT_SMART_VIEW_TRACKER' {$fileName = 'check-point-smartview-tracker_demo_log.log'}
            'CHECKPOINT_XML'                {$fileName = 'check-point-xml_demo_log.log'}   
            'CISCO_ASA'                     {$fileName = 'cisco-asa-firewall_demo_log.log'}
            'CISCO_ASA_FIREPOWER'           {$fileName = 'cisco-asa-firepower_demo_log.log'}
            'CISCO_FWSM'                    {$fileName = 'cisco-fwsm_demo_log.log'}
            'CISCO_IRONPORT_PROXY'          {$fileName = 'cisco-ironport-wsa_demo_log.log'}
            'CISCO_SCAN_SAFE'               {$fileName = 'cisco-scansafe_demo_log.log'}
            'CLAVISTER'                     {$fileName = 'clavister-ngfw-syslog_demo_log.log'}
            'FORCEPOINT'                    {$fileName = 'forcepoint-web-security-cloud_demo_log.log'} # NEW
            'FORTIGATE'                     {$fileName = 'fortinet-fortigate_demo_log.log'}
            'GENERIC_CEF'                   {$fileName = 'generic-cef-log_demo_log.log'}
            'GENERIC_LEEF'                  {$fileName = 'generic-leef-log_demo_log.log'} 
            'GENERIC_W3C'                   {$fileName = 'generic-w3c-log_demo_log.log'}
            'IBOSS'                         {$fileName = 'iboss-secure-cloud-gateway_demo_log.log'} # NEW
            'I_FILTER'                      {$fileName = 'digital-arts-i-filter_demo_log.log'}
            'JUNIPER_SRX'                   {$fileName = 'juniper-srx_demo_log.log'}
            'JUNIPER_SRX_SD'                {$fileName = 'juniper-srx-sd_demo_log.log'}
            'JUNIPER_SRX_WELF'              {$fileName = 'juniper-srx-welf_demo_log.log'}
            'JUNIPER_SSG'                   {$fileName = 'juniper-ssg_demo_log.log'}
            'MACHINE_ZONE_MERAKI'           {$fileName = 'meraki-urls-log_demo_log.log'}
            'MCAFEE_SWG'                    {$fileName = 'mcafee-web-gateway_demo_log.log'}
            'MICROSOFT_ISA_W3C'             {$fileName = 'microsoft-forefront-threat-management-gateway-w3c_demo_log.log'}
            'PALO_ALTO'                     {$fileName = 'pa-series-firewall_demo_log.log'}
            #'PALO_ALTO_SYSLOG'              {$fileName = ''} # No sample available
            'SONICWALL_SYSLOG'              {$fileName = 'sonicwall_demo_log.log'}
            'SOPHOS_CYBEROAM'               {$fileName = 'sophos-cyberoam-web-filter-and-firewall-log_demo_log.log'}
            'SOPHOS_SG'                     {$fileName = 'sophos-sg_demo_log.log'}
            'SOPHOS_XG'                     {$fileName = 'sophos-xg_demo_log.log'}  # NEW
            'SQUID'                         {$fileName = 'squid-common_demo_log.log'}
            'SQUID_NATIVE'                  {$fileName = 'squid-native_demo_log.log'}
            'WEBSENSE_SIEM_CEF'             {$fileName = 'web-security-solutions-internet-activity-log-cef_demo_log.log'}
            'WEBSENSE_V7_5'                 {$fileName = 'web-security-solutions-investigative-detail-report-csv_demo_log.log'}
            'ZSCALER'                       {$fileName = 'zscaler-default-csv_demo_log.log'}
            'ZSCALER_QRADAR'                {$fileName = 'zscaler-qradar-leef_demo_log.log'}
            'ZSCALER_CEF'                   {$fileName = 'zscaler-cef_demo_log.log'}
        }

        $zipFile = "$fileName.zip"
        Write-Verbose "Zip file to download will is $zipFile"

        $targetFolder = '{0}\{1}' -f $PWD,($fileName.Substring(0,($fileName.length-4)))
        Write-Verbose "Target folder for extracted log files is $targetFolder"

        # Download the sample log zip file
        try {
            Write-Verbose "Attempting to download $zipFile"
            Invoke-WebRequest -Method Get -Uri "https://adaproddiscovery.blob.core.windows.net/logs/$zipFile" -OutFile $zipFile -UseBasicParsing
        }
        catch {
            throw "Could not retrieve $zipFile. Exception was $_"
        }

        # Cleanup the target folder, if it already exists
        if (Test-Path $targetFolder) {
            Write-Verbose "The target folder $targetFolder already exists, so it will now be deleted"
            try {
                Write-Verbose "Attempting to delete the target folder $targetFolder"
                Remove-Item $targetFolder -Recurse -Force
            }
            catch {
                throw "Could not delete $targetFolder. Exception was $_"
            }
        }

        # Extract the files from the zip file (some contain more than one log in them)
        try {
            Write-Verbose "Attempting to extract contents of $zipFile to $targetFolder"
            [io.compression.zipfile]::ExtractToDirectory("$PWD\$zipFile",$targetFolder)
        }
        catch {
            throw "Could not extract contents of $zipFile : $_"
        }

        # Clean up the zip files, since we have extracted the contents
        try {
            Write-Verbose "Attempting to delete $zipFile"
            Remove-Item $zipFile -Force
        }
        catch {
            Write-Warning "Could not delete $zipFile : $_"
        }

        # Output to the caller the full path of each sample log file, unless output was suppressed
        if (!$Quiet) {
            (Get-ChildItem $targetFolder).FullName
        }
    }
    end {}
}