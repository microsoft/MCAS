---
external help file: MCAS-help.xml
Module Name: MCAS
online version:
schema: 2.0.0
---

# Get-MCASPortalSettings

## SYNOPSIS
Gets all your portal configuration including policy rules, user groups, and IP address ranges.

## SYNTAX

```
Get-MCASPortalSettings [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Get-MCASPortalSettings gets the portal configuration including policy rules, user groups, and IP address ranges of an MCAS tenant.

## EXAMPLES

### EXAMPLE 1
```
Get-MCASPortalSettings
```

userData                       : @{username=admin@jpoeppelgdpr2.onmicrosoft.com; observer=; tenant_domain=Contoso;
                                context_id=ec7b180e-3579-411c-8f29-bb092c60d5e0; is_invited_admin=;
                                tenant_id=17548853; allowed_tenants_details=System.Object\[\];
                                email=admin@jpoeppelgdpr2.onmicrosoft.com; should_show_cas_promotion=False;
                                permissions=}
samlProxyServerUrl             : us.saml.cas.ms
licenses                       : {AdallomStandalone, AdallomForO365}
configFeatures                 : @{CONSOLE_NOTIFY_USER_ACTION_ENABLED=True; CONSOLE_OLD_PROXY_ENABLED=False;
                                CONSOLE_IP_INVESTIGATION_TIMERANGE=30;
                                CONSOLE_APP_CONNECTORS_DRAWER_REQUESTS_RESULTS_EXCEED_LIMIT=0.75;
                                CONSOLE_DISCOVERY_ENABLED=True; CONSOLE_USER_GROUPS_MAX_ALLOWED_TAGS=500;
                                CONSOLE_ADMIN_QUARANTINE_PREVIEW_ENABLED=True;
                                CONSOLE_SECURITY_EXTENSIONS_CONTENTINSPECTION_PREVIEW_MODE_ENABLED=True;
                                CONSOLE_LIMITED_SETTINGS=False; REPOOPER_SMSLIMITPERDAY=10;
                                CONSOLE_SESSION_PROXY_ENABLED=True; CONSOLE_FILTER_ACTIVITIES_USER.ORGUNIT=True;
                                CONSOLE_INLINE_POLICY_PREVIEW_MODE_ENABLED=True; CONSOLE_ACCESS_PROXY_ENABLED=True;
                                CONSOLE_FILTER_ACTIVITIES_TEXT=True; CONSOLE_USER_INVESTIGATION_TIMERANGE=30;
                                PROXY_ACCESS_PROXY_ENABLED=True; CONSOLE_DISCOVERY_MAX_ALLOWED_APP_TAGS=10;
                                CONSOLE_DISCOVERY_MANUAL_UPLOADS_MAX_FILE_SIZE_GB=1; CONSOLE_SERVICES_ENABLED=True;
                                CONSOLE_DISCOVERY_SUB_DOMAINS_ENABLED=True;
                                CONSOLE_FILTERS_USER_QUERIES_MAX_COUNT=20;
                                CONSOLE_SESSION_POLICY_PREVIEW_MODE_ENABLED=True;
                                CONSOLE_APP_PERMISSIONS_ENABLED=True; CONSOLE_FIRST_PARTY_APP=True;
                                CONSOLE_SECURITY_EXTENSIONS_APITOKENS_ENABLED=True;
                                CONSOLE_FILTER_ACTIVITIES_FILELABELS=False; CONSOLE_ROLE_BASE_ACCESS_ENABLED=True;
                                CONSOLE_UPSELL_BRAND=; CONSOLE_DISCOVERY_DASHBOARD_O365_STATS=False;
                                CONSOLE_SERVICE_DASHBOARD_DEVICES_GRAPH_ENABLED=False;
                                CONSOLE_DISCOVERY_BLOCK_SCRIPT_ENABLED=True;
                                CONSOLE_FILTERS_QUERIES_FILTER_ENABLED=False;
                                CONSOLE_SECURITY_EXTENSIONS_ENABLED=True;
                                CONSOLE_ACTIVITY_DRAWER_USER_TAB_ENABLED=true; CONSOLE_SYNC_BAR_ENABLED=False;
                                CONSOLE_ADMIN_QUARANTINE_ENABLED=True; CONSOLE_INVESTIGATE_BASIC=;
                                CONSOLE_ALLOW_UNIQUE_TARGETS_ONLY=True;
                                CONSOLE_SECURITY_EXTENSIONS_CONTENTINSPECTION_ENABLED=True;
                                CONSOLE_DISCOVERY_USER_ENRICHMENT_ENABLED=True;
                                CONSOLE_SECURITY_EXTENSIONS_SIEMAGENTS_ENABLED=True;
                                CONSOLE_AZINFOPROTECTION_ENABLED=True;
                                CONSOLE_DISCOVERY_AUTOMATIC_UPLOAD_ENABLED=True;
                                CONSOLE_SECURITY_EXTENSIONS_SIEMAGENTS_MAX_COUNT=5; CONSOLE_USER_GROUPS_ENABLED=True;
                                CONSOLE_DISCOVERY_POLICY_ALLOWED=True; CONSOLE_DOCKER_LOG_COLLECTOR_ENABLED=True;
                                CONSOLE_DISCOVERY_ORG_UNITS_ENABLED=False; CONSOLE_FILES_ENABLED=True;
                                CONSOLE_FILTER_ACTIVITIES_AZURE_SUBSCRIPTION_ENABLED=False;
                                CONSOLE_ENTITIES_API_DISABLED=True; CONSOLE_PRODUCT_BRAND=cas;
                                CONSOLE_SUFFIX_DISCLAIMER_CONFIGURABLE=True;
                                CONSOLE_SECURITY_EXTENSIONS_APITOKENS_CREATE_ENABLED=True;
                                CONSOLE_OBJECT_POLICY_ENABLED=; CONSOLE_FILTER_ACTIVITIES_FILENAME_CONTAINS=False;
                                CONSOLE_DEFAULT_ROUTE=dashboard; CONSOLE_DISCOVERY_ANONYMIZATION_ENABLED=True;
                                CONSOLE_SESSION_POLICY_RMS_ENABLED=True; CONSOLE_PROXY_ENABLED=True;
                                CONSOLE_MCE_ENABLED=False; CONSOLE_BUILT_IN_REPORT_MANUAL_GENERATE=True;
                                CONSOLE_SERVICES_BOARDING_BAR_ENABLED=True; CONSOLE_ACTIVITY_LOG_ENABLED=True;
                                CONSOLE_DISCOVERY_APP_NOTE_ENABLED=True;
                                CONSOLE_APP_CONNECTORS_MAX_INSTANCES_PER_APP=1;
                                CONSOLE_MULTI_FACTOR_AUTH_ENABLED=False; CONSOLE_DISCOVERY_PROXY_EXPORT_ENABLED=True;
                                CONSOLE_OBJECT_POLICY_PREVIEW_MODE_ENABLED=True;
                                CONSOLE_DISCOVERY_MANUAL_UPLOADS_DAILY_LIMIT_WARNING_THRESHOLD=15;
                                CONSOLE_SECURITY_EXTENSIONS_APITOKENS_REENTER_PASSWORD_ENABLED=False;
                                CONSOLE_OMS_SETTINGS_ENABLED=False; CONSOLE_DISCOVERY_LANDING_PAGE_ENABLED=False;
                                CONSOLE_MANAGE_ADMINS_ACCESS=True;
                                CONSOLE_GOVERNANCE_GOOGLE_REMEDIATION_ENABLED=False;
                                CONSOLE_DRAWER_IP_TAB_ENABLED=True; CONSOLE_RMS_ENABLED=True;
                                CONSOLE_SIEMAGENTS_ENABLED=True; CONSOLE_FILE_POLICY_RMS_ENABLED=True;
                                CONSOLE_BAN_APP_REPLY_TO_ENABLED=False;
                                CONSOLE_SECURITY_EXTENSIONS_OTHEREXTENSIONS_PREVIEW_MODE_ENABLED=True;
                                CONSOLE_ACTIVITY_LOG_TAB_ENABLED=; CONSOLE_DISCOVERY_BRAND=cas;
                                CONSOLE_ANUBIS_ENABLED=False; PROXY_SUFFIX_DISABLED_APPS=System.Object\[\];
                                CONSOLE_CUSTOM_REPORTS_ENABLED=True; CONSOLE_DISCOVERY_SETTINGS_ENABLED=True;
                                CONSOLE_DISCOVERY_ENTITIES_ENABLED=True;
                                CONSOLE_SECURITY_EXTENSIONS_OTHEREXTENSIONS_ENABLED=False;
                                CONSOLE_BUILTIN_REPORTS_ENABLED=True; CONSOLE_APP_CONNECTORS_DRAWER=true;
                                CONSOLE_DISCOVERY_MANUAL_UPLOADS_DAILY_LIMIT=20;
                                CONSOLE_ACTIVITY_LOG_IP_TAGS_ENRICHMENT_ENABLED=True;
                                CONSOLE_YAMMER_API_CONNECTOR_ENABLED=False; CONSOLE_USER_NOTIFICATIONS_ENABLED=False;
                                PROXY_SESSION_PROXY_ENABLED=True; CONSOLE_DASHBOARD_ENABLED=True;
                                CONSOLE_FILTER_ACTIVITIES_TYPE_HIERARCHY_ENABLED=False;
                                REPOOPER_MAILQUOTAPERWINDOW=500; CONSOLE_DISCOVERY_ANOMALY_POLICY_ALLOWED=True;
                                CONSOLE_EXCHANGE_ONLINE_API_CONNECTOR_ENABLED=False;
                                CONSOLE_USER_GROUPS_MINIFIED_FILTERS=False;
                                CONSOLE_DISABLE_CONSENT_BUTTON_ENABLED=False;
                                CONSOLE_BUILT_IN_REPORT_HIDE_GEOLOCATION_SUMMARY=True;
                                CONSOLE_INVESTIGATE_ENABLED=True; CONSOLE_REPORTS_IP_USAGE_INTERNAL=True;
                                CONSOLE_BUILT_IN_REPORT_HIDE_IP_ADMIN_USAGE=True; CONSOLE_ENTITIES_API_ENABLED=False;
                                CONSOLE_ACCESS_PROXY_VISIBLE=True; CONSOLE_WORKDAY_API_CONNECTOR_ENABLED=False;
                                CONSOLE_DRAWER_USER_TAB_ENABLED=true;
                                CONSOLE_SECURITY_EXTENSIONS_SIEMAGENTS_ACTIVITIES_ENABLED=True;
                                CONSOLE_API_DOCUMENTATION_ENABLED=True; CONSOLE_AZURE_API_CONNECTOR_ENABLED=False;
                                CONSOLE_DISCOVERY_RISK_SCORE_ENABLED=True; CONSOLE_USERS_PAGE_ENABLED=True;
                                CONSOLE_NAVBAR_SEARCH_ENABLED=True}
consoleVersion                 : 0.114.118
privacyUrl                     : http://go.microsoft.com/fwlink/?LinkId=512132
policyTypes                    : {@{altIcon=images/reports/report.activity.color.alt.svg;
                                icon=images/reports/report.activity.color.svg; id=AUDIT;
                                title=CONSOLE_POLICY_TYPE_ACTIVITY_POLICY},
                                @{altIcon=images/reports/report.anomaly.color.alt.svg;
                                icon=images/reports/report.anomaly.color.svg; id=ANOMALY_DISCOVERY;
                                title=CONSOLE_POLICY_TYPE_DISCOVERY_ANOMALY_POLICY},
                                @{altIcon=images/reports/report.file.color.alt.svg;
                                icon=images/reports/report.file.color.svg; id=FILE;
                                title=CONSOLE_POLICY_TYPE_FILE_POLICY},
                                @{altIcon=images/reports/report.anomaly.color.alt.svg;
                                icon=images/reports/report.anomaly.color.svg; id=ANOMALY_DETECTION;
                                title=CONSOLE_POLICY_TYPE_ANOMALY_DETECTION_POLICY}...}
enabledFeatures                : {SUFFIX_PROXY}
msServices                     : @{11161=; 11394=; 20595=}
remoteUploadProvider           : 1
serviceClasses                 : @{11522=; 11161=; 20892=; 20893=; 26060=; 14509=; 12275=; 25275=; 23233=; 26055=;
                                17865=; 20940=; 11599=; 10980=; 12260=; 12005=; 19688=; 11114=; 11627=; 15600=;
                                20595=; 10489=; 11770=}
tenantConfig                   : @{inlinePolicy=False; allowAzureIP=True; emailMaskPolicy=MASKED_SUBJECT;
                                enable_preview_functionality=False; enableNrtDlpScan=False;
                                enableDiscoveryConsultancy=False; eDiscovery=False;
                                discoveryManualUploads=System.Object\[\]; internalDomains=System.Object\[\];
                                orgDisplayName=Contoso; querycacher_poker_aggregate=False;
                                discoveryMasterTimeZone=Etc/GMT; enableMediaDLP=False; ignoreExternalAzureIP=False;
                                tenantEmail=}
loggedInWithSSO                : False
stories                        : @{0=; 1=; 2=; 3=; 4=; 5=; 7=; 8=}
permissionFlags                : @{CONSOLE_CONNECT_APP_PERMITTED=True; CONSOLE_DISCOVERY_SETTINGS_PERMITTED=True;
                                CONSOLE_CREATE_POLICY_PERMITTED=True; CONSOLE_GOVERNANCE_ACTION_PERMITTED=True;
                                CONSOLE_DISCOVERY_UPLOAD_PERMITTED=True; CONSOLE_ADD_IP_ADDRESS_RANGE_PERMITTED=True;
                                CONSOLE_ADD_SIEM_AGENT_PERMITTED=True}
showServiceSyncBar             : False
isAdallomFlavour               : False
is_O365_first_party_app_deploy : True
runtime                        : @{LOCALE=en; FULL_LOCALE=en-US; MOMENT_LOCALE=en; TRANSLATION_FILE=en-US}
isMicrosoftFlavour             : True

## PARAMETERS

### -Credential
Specifies the credential object containing tenant as username (e.g.
'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $CASCredential
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
