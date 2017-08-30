<#
.Synopsis
   Exports a proxy or firewall block script for the unsanctioned apps in your Cloud App Security tenant.
.DESCRIPTION
   Exports a block script, in the specified firewall or proxy device type format, for the unsanctioned apps.

   'Export-MCASBlockScript -Appliance <device format>' returns the text to be used in a Websense block script. Methods available are only those available to custom objects by default.
.EXAMPLE
   Export-MCASBlockScript -Appliance WEBSENSE

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
   Export-MCASBlockScript -Appliance BLUECOAT_PROXYSG

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
   Export-MCASBlockScript -Appliance WEBSENSE | Set-Content MyWebsenseBlockScript.txt -Encoding UTF8

   This pulls back a Websense block script in text string format and creates a new UTF-8 encoded text file out of it.
.FUNCTIONALITY
   Export-MCASBlockScript is intended to function as an export mechanism for obtaining block scripts from Cloud App Security.

#>
function Export-MCASBlockScript
{
    [CmdletBinding()]
    [Alias('Export-CASBlockScript')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Specifies the appliance type to use for the format of the block script. Possible Values: BLUECOAT_PROXYSG, CISCO_ASA, FORTINET_FORTIGATE, PALO_ALTO, JUNIPER_SRX, WEBSENSE
        [Parameter(Mandatory=$true,ValueFromPipeline=$false,Position=0)]
        [blockscript_format]$Appliance
    )

    Try {$TenantUri = Select-MCASTenantUri}
        Catch {Throw $_}

    Try {$Token = Select-MCASToken}
        Catch {Throw $_}

    Try {
        $Response = Invoke-MCASRestMethod2 -Uri ("https://$TenantUri/api/discovery_block_scripts/?format="+($Appliance -as [int])) -Method Get -Token $Token
    }
        Catch {
            Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
        }

    $Response = $Response.Content

    $Response
}
