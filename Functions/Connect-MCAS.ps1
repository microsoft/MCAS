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
    param()


    #$Authority = 'https://login.microsoftonline.com/common'
    
    $displayName = 'jpoeppel-PS-test-public-client'
    $clientId = '7c5c030a-983f-4832-93df-b5a316971c20' # Client ID registered as public client
    #$tenantId = 'eb81c4c9-2546-43f2-8c43-9c2295af4b88'
    #$objectId = 'e2c6fd06-ca45-4fae-ac87-74bac46d38b5'
    #$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

    # Need error handling
    #$appManifestJson = Get-Content -Raw -Path (Resolve-Path "$ModulePath/config/$appManifestFile") | ConvertFrom-Json
    
    $displayName = $appManifestJson.name
    $clientId = $appManifestJson.appId
    

    $scopes = @()
    #$scopes += 'https://microsoft.onmicrosoft.com/873153a1-b75b-46d9-8a18-ccaaa0785781/user_impersonation' # Permission to 'Access Microsoft Cloud App Security'
    #$scopes += 'https://graph.microsoft.com/User.Read'                                                     # Permission to 'Sign in and read user profile'

    #$scopes += 'https://microsoft.onmicrosoft.com/873153a1-b75b-46d9-8a18-ccaaa0785781//user_impersonation' # Permission to 'Access Microsoft Cloud App Security'
    $scopes += 'https://graph.microsoft.com//User.Read'                                                     # Permission to 'Sign in and read user profile'


    Write-Verbose "Initializing MSAL public client interface"
    try {
    }
    catch {
        throw "An error occurred occurred initializing MSAL public client interface. The error was $_"
    }   

    
    Write-Verbose "Attempting to acquire a token"
    try {
    }
    catch {
        throw "An error occurred attempting to acquire a token. The error was $_"
    }   



}


















<#


###################################
#### DO NOT MODIFY BELOW LINES ####
###################################
Function Expand-Collections {
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [psobject]$MSGraphObject
    )
    Begin {
        $IsSchemaObtained = $False
    }
    Process {
        If (!$IsSchemaObtained) {
            $OutputOrder = $MSGraphObject.psobject.properties.name
            $IsSchemaObtained = $True
        }

        $MSGraphObject | ForEach-Object {
            $singleGraphObject = $_
            $ExpandedObject = New-Object -TypeName PSObject

            $OutputOrder | ForEach-Object {
                Add-Member -InputObject $ExpandedObject -MemberType NoteProperty -Name $_ -Value $(($singleGraphObject.$($_) | Out-String).Trim())
            }
            $ExpandedObject
        }
    }
    End {}
}

Function Get-Headers {
    param( $token )

    Return @{
        "Authorization" = ("Bearer {0}" -f $token);
        "Content-Type" = "application/json";
    }
}





# from https://adamtheautomator.com/microsoft-graph-api-powershell/

#
# Define AppId, secret and scope, your tenant name and endpoint URL
$AppId = '2d10909e-0396-49f2-ba2f-854b77c1e45b'
$AppSecret = 'abcdefghijklmnopqrstuv12345'
$Scope = "https://graph.microsoft.com/.default"
$TenantName = "contoso.onmicrosoft.com"

$Url = "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token"

# Add System.Web for urlencode
Add-Type -AssemblyName System.Web

# Create body
$Body = @{
    client_id = $AppId
	client_secret = $AppSecret
	scope = $Scope
	grant_type = 'client_credentials'
}

# Splat the parameters for Invoke-Restmethod for cleaner code
$PostSplat = @{
    ContentType = 'application/x-www-form-urlencoded'
    Method = 'POST'
    # Create string by joining bodylist with '&'
    Body = $Body
    Uri = $Url
}

# Request the token!
$Request = Invoke-RestMethod @PostSplat

#>