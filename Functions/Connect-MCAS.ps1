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
        [string]$TenantUri,

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

    $msGraphScopes = @()
    $msGraphScopes += 'https://graph.microsoft.com//User.Read'               # Permission to 'Sign in and read user profile' --> Required to sign in
    $msGraphScopes += 'https://graph.microsoft.com//Organization.Read.All'   # Permission to 'Read organization information' --> Required to lookup tenant name 
    
    $mcasScopes = @()
    #$mcasScopes += 'openid'
    $mcasScopes += 'https://microsoft.onmicrosoft.com/873153a1-b75b-46d9-8a18-ccaaa0785781/user_impersonation'   # Permission to 'Access Microsoft Cloud App Security' --> Required to access the MCAS API endpoints

    #$mcasScopes += '25a6a87d-1e19-4c71-9cb0-16e88ff608f1'


    Write-Verbose "Initializing MSAL public client app"
    try {
        $msalPublicClient = New-MsalClientApplication -ClientId $clientId -RedirectUri $redirectUri -Authority $authority
    }
    catch {
        throw "An error occurred initializing MSAL public client interface. The error was $_"
    }   
   
    Write-Verbose "Attempting to acquire a token"
    try {
          $authResult = Get-MsalToken -ClientId $clientId -RedirectUri $redirectUri -Scopes $mcasScopes #-Authority $authority 
    }
    catch {
        throw "An error occurred attempting to acquire a token. The error was $_"
    }   
  
    $rawToken = $($authResult.AccessToken)
    $token = Decode-JWT $rawToken
    #Write-Information $token
    Write-Verbose $token.claims
    #$tenantId = $token.claims.tid
  
    $authHeader = @{'Authorization'="bearer $($authResult.AccessToken)"}


    if ($null -eq $TenantUri) {          
        Write-Verbose "The tenant URI was not specified, so auto-detection will now be attempted."
        
        try {
            #$TenantUri = Invoke-WebRequest -Uri 'https://portal.cloudappsecurity.com/get_regional_url/' -Method Get -Headers $authHeader -Verbose
        }
        catch {
            throw "An error occurred attempting retrieve regional URL of of MCAS tenant from https://portal.cloudappsecurity.com/get_regional_url/. The error was $_"
        }
    }
    else {
        Write-Verbose "The tenant URI was specified, so auto-detection was not attempted."
    }
    

    Write-Verbose "Tenant URI is $TenantUri"
    
    Write-Verbose "Token is $rawToken"
    #$mcasOAuthToken = ConvertTo-SecureString $rawToken -AsPlainText -Force

    #[System.Management.Automation.PSCredential]$Global:CASCredential = New-Object System.Management.Automation.PSCredential ($TenantUri, $mcasOAuthToken)

    #$TenantUri
    $authHeader

    # If -PassThru is specified, write the credential object to the pipeline (the global variable will also be exported to the calling session with Export-ModuleMember)
    if ($PassThru) {
        $CASCredential
    }
}