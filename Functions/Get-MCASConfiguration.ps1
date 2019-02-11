<#
.Synopsis
   Retrieves MCAS configuration settings. 
.DESCRIPTION
   Get-MCASConfiguration lists the settings, of the specified type, of the MCAS tenant.

.EXAMPLE
    PS C:\> Get-MCASConfiguration

    environmentName            : Contoso
    omsWorkspaces              :
    quarantineSite             :
    ssoNewSPEntityId           : https://contoso.portal.cloudappsecurity.com/saml/consumer
    ssoSPEntityId              : https://contoso.portal.cloudappsecurity.com/saml/consumer
    emailMaskPolicyOptions     : @{FULL_CONTENT=CONSOLE_GENERAL_SETTINGS_EMAIL_MASK_POLICIES_NAME_FULL_CONTENT;
                                MASKED_SUBJECT=CONSOLE_GENERAL_SETTINGS_EMAIL_MASK_POLICIES_NAME_MASKED_SUBJECT;
                                ONLY_ID=CONSOLE_GENERAL_SETTINGS_EMAIL_MASK_POLICIES_NAME_ONLY_ID}
    ssoEntityId                :
    ssoCertificate             :
    ssoHasMetadata             : True
    ssoEnabled                 : False
    allowAzIP                  : True
    ssoSignInPageUrl           :
    canChangeAllowAzIP         : True
    quarantineUserNotification : This file was quarantined because it might conflict with your organization's security and
                                compliance policies. Contact your IT administrator for more information.
    ssoSignOutPageUrl          :
    languageData               : @{tenantLanguage=default; availableLanguages=System.Object[]}
    discoveryMasterTimeZone    : Etc/GMT
    ssoOldSPEntityId           : https://us.portal.cloudappsecurity.com/saml/consumer?tenant_id=26034820
    ssoByDomain                : True
    ignoreExternalAzIP         : False
    ssoLockdown                : False
    ssoSPLogoutId              : https://contoso.portal.cloudappsecurity.com/saml/logout
    ssoSignAssertion           : False
    showAllowAzIP              : True
    emailMaskPolicy            : MASKED_SUBJECT
    orgDisplayName             : Contoso
    domains                    : {contoso.onmicrosoft.com}
    showSuffixDisclaimer       : True
    logoFilePath               :

.EXAMPLE
    PS C:\> Get-MCASConfiguration -Settings Mail

    fromDisplayName replyTo from                                 htmlTemplate
    --------------- ------- ----                                 ------------
    ContosoSecurity         security@contoso.com

.FUNCTIONALITY
   Get-MCASConfiguration is intended to return the configuration settings of an MCAS tenant.
#>
function Get-MCASConfiguration {
    [CmdletBinding()]
    param (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies which setting types to list. Possible Values: 'General'(default),'Mail','ScoreMetrics','SnapshotReports','ContinuousReports','AppTags','UserEnrichment','Anonymization','InfoProtection','ManagedDevices'
        [Parameter(Mandatory=$false,Position=0)]
        [ValidateSet('General','Mail','ScoreMetrics','SnapshotReports','ContinuousReports','AppTags','UserEnrichment','Anonymization','InfoProtection','ManagedDevices')]
        [string]$Settings = 'General'
    )

    $returnResponseDataProperty = $false

    switch ($Settings) {
        'General'           {$path = '/cas/api/v1/settings/'}
        'Mail'              {$path = '/cas/api/v1/mail_settings/get/';                          $responsePropertyNeeded = 'tenantEmail'}  
        'ScoreMetrics'      {$path = '/cas/api/v1/discovery/weights/';                          $responsePropertyNeeded = 'fields'}  # Need to map ids to risk factors
        'SnapshotReports'   {$path = '/cas/api/v1/discovery/snapshot_reports/';                 $responsePropertyNeeded = 'data'}  
        'ContinuousReports' {$path = '/cas/api/v1/discovery/continuous_reports/';               $responsePropertyNeeded = 'data'} 
        'AppTags'           {$path = '/cas/api/v1/discovery/app_tags/';                         $responsePropertyNeeded = 'data'} 
        'UserEnrichment'    {$path = '/cas/api/v1/tenant_config/resolveDiscoveryUserWithAAD/'}
        'Anonymization'     {$path = '/cas/api/v1/discovery/get_encryption_settings/';          $responsePropertyNeeded = 'data'} 
        'InfoProtection'    {$path = '/cas/api/v1/settings/'}
        'ManagedDevices'    {$path = '/cas/api/v1/managed_devices/get_data';                    $responsePropertyNeeded = 'data'}
    }

    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path $path -Method Get
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    if ($responsePropertyNeeded) {
        $response.$responsePropertyNeeded
    }
    else {
        $response
    }
}