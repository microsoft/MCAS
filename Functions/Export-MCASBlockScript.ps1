<#
.Synopsis
   Exports a proxy or firewall block script for the unsanctioned apps in your Cloud App Security tenant.
.DESCRIPTION
   Exports a block script, in the specified firewall or proxy device type format, for the unsanctioned apps.

   'Export-MCASBlockScript -DeviceType <device format>' returns the text to be used in a Websense block script. Methods available are only those available to custom objects by default.
.EXAMPLE
    PS C:\> Export-MCASBlockScript -DeviceType WEBSENSE

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

.EXAMPLE
    PS C:\> Export-MCASBlockScript -DeviceType BLUECOAT_PROXYSG

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

.EXAMPLE
    PS C:\> Export-MCASBlockScript -DeviceType WEBSENSE | Set-Content MyWebsenseBlockScript.txt -Encoding UTF8

    This pulls back a Websense block script in text string format and creates a new UTF-8 encoded text file out of it.
.FUNCTIONALITY
   Export-MCASBlockScript is intended to function as an export mechanism for obtaining block scripts from Cloud App Security.

#>
function Export-MCASBlockScript {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the device type to use for the format of the block script. Possible Values: BLUECOAT_PROXYSG,CISCO_ASA,FORTINET_FORTIGATE,PALO_ALTO,JUNIPER_SRX,WEBSENSE,ZSCALER
        [Parameter(Mandatory=$true,ValueFromPipeline=$false,Position=0)]
        [ValidateSet('BLUECOAT','CISCO_ASA','FORTIGATE','PALO_ALTO','JUNIPER_SRX','WEBSENSE_V7_5','ZSCALER')]
        [alias("Appliance")]
        [device_type]$DeviceType
    )

    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path ("/api/discovery_block_scripts/?format="+($DeviceType -as [int])) -Method Get
    }
    catch {
        throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
    }

    $response
}