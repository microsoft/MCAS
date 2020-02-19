<#
.Synopsis
   Authenticates to MCAS and initializes 
.DESCRIPTION
   Get-MCASAppId gets the unique identifier integer value that represents an app in MCAS.

.EXAMPLE
    PS C:\> Connect-MCAS

.FUNCTIONALITY
   Connect-MCAS returns nothing
#>
function Connect-MCAS {
    [CmdletBinding()]
    param
    (
        # Specifies the portal URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantUri = 'damdemo.us.portal.cloudappsecurity.com',

        # Specifies that the credential object should also be returned into the pipeline for further processing.
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    )

    #$displayName = 'jpoeppel-PS-test-public-client'
    $clientId = '7c5c030a-983f-4832-93df-b5a316971c20' # Client ID registered as public client in damdemo.ca directory (name = jpoeppel-PS-test-public-client)
    #$clientId = 'c4bd3cbe-226c-43fd-a9ef-07b829f1d167' # Client ID registered as public client in microsoft.com directory (name = jpoeppel-PS-test-public-client)
    $redirectUri = 'http://localhost'
    #$redirectUri = "msal{0}://auth" -f $clientId
    $authority = 'https://login.microsoftonline.com/common/'

    Write-Verbose "Reading $appManifestFile"
    Try {
        #$appManifestJson = Get-Content -Raw -Path (Resolve-Path "$ModulePath/config/$appManifestFile") | ConvertFrom-Json
    }
    Catch {
        throw "An error occurred reading $appManifestFile. The error was $_"
    }

    #$displayName = $appManifestJson.name
    #$clientId = $appManifestJson.appId

    $scopes = @()
    #$scopes += 'https://graph.microsoft.com//User.Read'                                                      # Permission to 'Sign in and read user profile' --> Required to sign in
    #$scopes += 'https://graph.microsoft.com//Organization.Read.All'                                          # Permission to 'Read organization information' --> Required to lookup tenant name
    $scopes += 'https://microsoft.onmicrosoft.com/873153a1-b75b-46d9-8a18-ccaaa0785781/user_impersonation'  # Permission to 'Access Microsoft Cloud App Security' --> Required to access the MCAS API endpoints
    
    Write-Verbose "Initializing MSAL public client app"
    try {
        $msalPublicClient = New-MsalClientApplication -ClientId $clientId -RedirectUri $redirectUri -Authority $authority
    }
    catch {
        throw "An error occurred initializing MSAL public client interface. The error was $_"
    }   
   
    Write-Verbose "Attempting to acquire a token"
    try {
          $authResult = Get-MsalToken -ClientId $clientId -RedirectUri $redirectUri -Scopes $scopes #-Authority $authority 
    }
    catch {
        throw "An error occurred attempting to acquire a token. The error was $_"
    }   
  
    $rawToken = $($authResult.AccessToken)

    $token = Decode-JWT $rawToken
    Write-Verbose $token.claims
    #$tenantId = $token.claims.tid
  
    $authHeader = @{'Authorization'="Bearer $($authResult.AccessToken)"}

    ## ERROR HANDLING ##
    #$me = Invoke-WebRequest -Uri "https://graph.microsoft.com/v1.0/me" -Method Get -ContentType 'application/json' -Headers $authHeader
    #$apps = Invoke-WebRequest -Uri "https://graph.microsoft.com/v1.0/applications" -Method Get -ContentType 'application/json' -Headers $authHeader
    #


    # If tenant URI is not specified, attempt to auto-detection
    if ($null -eq $TenantUri) {          
        
        Write-Verbose "Attempting to retrieve organization information from Microsoft Graph API"
        try {
            $org = Invoke-WebRequest -Uri "https://graph.microsoft.com/v1.0/organization" -Method Get -ContentType 'application/json' -Headers $authHeader 
        }
        catch {
            throw "An error occurred attempting to retrieve organization information from Microsoft Graph API. The error was $_"
        }
        
        # Build the tenant URI from 
        $initialTenantDomain = (($org.Content | ConvertFrom-Json).value.verifiedDomains | Where-Object {$_.isInitial}).name
        $prefix = $initialTenantDomain.Split('.')[0]
        $region = 'us'
        $TenantUri = "{0}.{1}.portal.cloudappsecurity.com" -f $prefix,$region
    }

    Write-Verbose "Tenant URI is $TenantUri"
    
    Write-Verbose "Token is $rawToken"
    $mcasOAuthToken = ConvertTo-SecureString $rawToken -AsPlainText -Force

    [System.Management.Automation.PSCredential]$Global:CASCredential = New-Object System.Management.Automation.PSCredential ($TenantUri, $mcasOAuthToken)

    # Validate the tenant URI provided
    if (!($CASCredential.GetNetworkCredential().username.EndsWith('.portal.cloudappsecurity.com'))) {
        throw "Invalid tenant uri specified as the username of the credential. Format should be <tenantname>.<tenantregion>.portal.cloudappsecurity.com. For example, contoso.us.portal.cloudappsecurity.com or tailspintoys.eu.portal.cloudappsecurity.com."
    }

    # Post to the MCAS OAuth2 endpoint (since MCAS contains its own token service)
    $mcasOAuth2Endpoint = "https://portal.cloudappsecurity.com/oauth2/login?client_id=$clientId&scope=user_impersonation&grant_type=client_credentials"   
    
    $Body = @{
        client_id = $clientId
        scope = $scopes
        grant_type = 'client_credentials'
    }   
    $authHeader = @{'Authorization'="Bearer $rawToken)"}

    # Splat the parameters for Invoke-Restmethod for cleaner code
    $PostSplat = @{
        ContentType = 'application/json'
        Method = 'POSt'
        Uri = $mcasOAuth2Endpoint
        Headers = $authHeader
    }
    
    $result = Invoke-WebRequest @PostSplat
    
    $result

    # If -PassThru is specified, write the credential object to the pipeline (the global variable will also be exported to the calling session with Export-ModuleMember)
    if ($PassThru) {
        $CASCredential
    }
}