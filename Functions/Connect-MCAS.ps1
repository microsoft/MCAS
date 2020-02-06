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

    #$msalHelper = New-Object
}


<#
function Get-AdalAuthZHeader
{
    [CmdletBinding()]
    Param
    (
        # ClientID for  AquireToken() method
        [Parameter(Mandatory=$true)]
        [string]$ClientId,

        # Redirect URI for AquireToken() method (default='urn:ietf:wg:oauth:2.0:oob')
        [Parameter(Mandatory=$false)]
        [string]$RedirectUri = 'urn:ietf:wg:oauth:2.0:oob',
        
        # Authority to use for the AuthenticationContext object (default='https://login.microsoftonline.com/Common')
        [Parameter(Mandatory=$false)]
        [string]$Authority = 'https://login.microsoftonline.com/common'
    )
    
    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $Authority,$false
    
    try {
        $authResult = $authContext.AcquireToken("https://graph.microsoft.com",$ClientId,$RedirectUri,[Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always)
    }
    catch {
        throw "An error occurred calling the AuthenticationContext.AquireToken() method. The error was $_"
    }

    $headerParams = @{'Authorization'="$($authResult.AccessTokenType) $($authResult.AccessToken)"}
    
    $headerParams
}


function Invoke-AdalAuthN
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$Resource = "https://graph.microsoft.com",
        
        # ClientID for  AquireToken() method
        [Parameter(Mandatory=$true)]
        [string]$ClientId,

        # Redirect URI for AquireToken() method (default='urn:ietf:wg:oauth:2.0:oob')
        [Parameter(Mandatory=$false)]
        [string]$RedirectUri = 'urn:ietf:wg:oauth:2.0:oob',
        
        # Authority to use for the AuthenticationContext object (default='https://login.microsoftonline.com/Common')
        [Parameter(Mandatory=$false)]
        [string]$Authority = 'https://login.microsoftonline.com/common',

        [switch]$Silent
    )
    
    $global:authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $Authority,$false
    
    try {
        if ($Silent) {
            $authResult = $authContext.AcquireToken($Resource,$ClientId,$RedirectUri)
        }
        else {
            $authResult = $authContext.AcquireToken($Resource,$ClientId,$RedirectUri,[Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always)
        }
    }
    catch {
        throw "An error occurred calling the AuthenticationContext.AquireToken() method. The error was $_"
    }

    $authResult
}

function Import-ADAL {   
    $moduleDirPath = [Environment]::GetFolderPath("MyDocuments") + "\WindowsPowerShell\Modules"
    
    $modulePath = $moduleDirPath + "\AADGraph"
    
    if(-not (Test-Path ($modulePath+"\Nugets"))) {
        New-Item -Path ($modulePath+"\Nugets") -ItemType "Directory" | out-null
    }
    
    $adalPackageDirectories = (Get-ChildItem -Path ($modulePath+"\Nugets") -Filter "Microsoft.IdentityModel.Clients.ActiveDirectory*" -Directory)
    
    if($adalPackageDirectories.Length -eq 0){
        Write-Warning "Active Directory Authentication Library Nuget doesn't exist. Downloading now ..."
        
        if(-not(Test-Path ($modulePath + "\Nugets\nuget.exe"))) {
            Write-Warning "nuget.exe not found. Downloading from http://www.nuget.org/nuget.exe ..."
            
            #$wc = New-Object System.Net.WebClient
            #$wc.DownloadFile("http://www.nuget.org/nuget.exe",$modulePath + "\Nugets\nuget.exe")

            (New-Object System.Net.WebClient).DownloadFile("http://www.nuget.org/nuget.exe",$modulePath + "\Nugets\nuget.exe")
        }
        
        $nugetDownloadExpression = $modulePath + "\Nugets\nuget.exe install Microsoft.IdentityModel.Clients.ActiveDirectory -Version 2.14.201151115 -OutputDirectory " + $modulePath + "\Nugets | out-null"
        
        Invoke-Expression $nugetDownloadExpression
    }

    $adalPackageDirectories = (Get-ChildItem -Path ($modulePath+"\Nugets") -Filter "Microsoft.IdentityModel.Clients.ActiveDirectory*" -Directory)
    
    $ADAL_Assembly = (Get-ChildItem "Microsoft.IdentityModel.Clients.ActiveDirectory.dll" -Path $adalPackageDirectories[$adalPackageDirectories.length-1].FullName -Recurse)
    
    $ADAL_WindowsForms_Assembly = (Get-ChildItem "Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll" -Path $adalPackageDirectories[$adalPackageDirectories.length-1].FullName -Recurse)
    
    if($ADAL_Assembly.Length -gt 0 -and $ADAL_WindowsForms_Assembly.Length -gt 0){
        Write-Verbose "Loading ADAL Assemblies ..."
        try {
            [System.Reflection.Assembly]::LoadFrom($ADAL_Assembly[0].FullName) | out-null
            [System.Reflection.Assembly]::LoadFrom($ADAL_WindowsForms_Assembly.FullName) | out-null
        }
        catch {
            throw "An error occurred trying to load the assemblies. The error was $_"
        }
        $true
    }
    else{
        Write-Warning "Cleaning up Active Directory Authentication Library package directories ..."
        try {
            $adalPackageDirectories | Remove-Item -Recurse -Force | Out-Null
        }
        catch
        {
            Write-Error "An error occurred trying to clean up the $adalPackageDirectories. The error was $_"
        }

        Write-Warning "Not able to load ADAL assembly. Delete the Nugets folder under" $modulePath ", restart PowerShell session and try again ..."
        
        $false
    }
}


function Get-AccessToken($tenantId) {
    $cache = [Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache]::DefaultShared
    $cacheItem = $cache.ReadItems() | Where-Object { $_.TenantId -eq $tenantId } | Select-Object -First 1
    return $cacheItem.AccessToken
}


#$redirectUri = "http://localhost/"

#$authority = "https://login.windows.net/" + $tenantdomain
#$authority = "https://login.windows.net/Common" #+ $tenantdomain

#$tenantdomain = "jpoeppelnoprev.onmicrosoft.com"


#$redirectUri = 'urn:ietf:wg:oauth:2.0:oob' # AzureAD and EXO modules
#$redirectUri = 'https://localhost'
#$redirectUri = 'https://portal.cloudappsecurity.com/oauth2/login' # MCAS
#$redirectUri = 'https://webshell.suite.office.com/iframe/TokenFactoryIframe' # Office 365 Report web site fiddler
#$redirectUri = 'https://calc.microsoft.com' # Calc

   
##############################################
#$clientID = "1950a258-227b-4e31-a9cf-717495945fc2" # AzureAD PS module (from web)
#$clientID = "05a65629-4c1b-48c1-a78b-804c4abdd4af" # MCAS client id
#$clientID = "1b730954-1685-4b74-9bfd-dac224a7b894" # fiddler trace of Connect-AzureAD
#$clientID = "507bc9da-c4e2-40cb-96a7-ac90df92685c" # Office 365 Reports
#$clientID = "89bee1f7-5e6e-4d8a-9f3d-ecd601259da7" # Office 365 Report web site fiddler
#$clientID = "a0c73c16-a7e3-4564-9a95-2bdf47383716" # EXO module
#$clientID = "de8bc8b5-d9f9-48b1-a8ad-b748da725064" # Graph Explorer
#$clientID = "a84be226-29a2-47f2-ad3c-cee5a0121010" # calc.microsoft.com
#$clientID = "b794af4d-11a3-4fc1-ac09-fcc764f3d83d" # JaredPS-Console1 Native app urn:ietf:wg:oauth:2.0:oob perms: read reports/users

$redirectUri = 'urn:ietf:wg:oauth:2.0:oob'


if (!$adalLoaded) {$adalLoaded = Import-ADAL}

#$headerParams = Get-AdalAuthZHeader -ClientId $clientID -RedirectUri $redirectUri

$authResult = Invoke-AdalAuthN -ClientId $clientID -RedirectUri $redirectUri
#$authResult2 = Invoke-AdalAuthN -ClientId $clientID -Silent

#$authResult3 = Invoke-AdalAuthN -Resource 'a84be226-29a2-47f2-ad3c-cee5a0121010' -ClientId $clientID -RedirectUri $redirectUri

#$clientCert = 'FSimuFrFNoC0sJXGmv13nNZceDc'


$tenantId = $authResult.TenantId

$headerParams = @{'Authorization'="$($authResult.AccessTokenType) $($authResult.AccessToken)"}




#$response = Invoke-RestMethod -UseBasicParsing -Headers $headerParams -Uri "https://graph.microsoft.com/v1.0/reports/getEmailAppUsageUserDetail(period='D180')"  -Method Get

#$response





$cache = [Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache]::DefaultShared
$token = $cache.ReadItems()

if ($token.IsMultipleResourceRefreshToken) {
    $mrrt = $token.RefreshToken
}



#$response = Invoke-RestMethod -UseBasicParsing -Headers $headerParams -Uri "https://graph.microsoft.com/v1.0/users/"  -Method Get
#$response = Invoke-RestMethod -UseBasicParsing -Method Post -Headers $headerParams -Uri ("https://manage.office.com/api/v1.0/{0}/activity/feed/subscriptions/start?contentType=Audit.General" -f ($authResult.TenantId)) -ContentType 'application/json' -Verbose

#>






































<#


#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`$filter=createdDateTime%20ge%202018-08-08T04:00:00Z%20and%20createdDateTime%20le%202018-08-15T17:05:57.161Z&`$top=1000"
#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`&`$filter=userPrincipalName eq 'Wasim.Ali@ap.jll.com' and appId eq '00000002-0000-0ff1-ce00-000000000000'"
#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`&`$filter=appId eq '00000002-0000-0ff1-ce00-000000000000'"
#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`&`$filter=appId eq '00000002-0000-0ff1-ce00-000000000000' and clientAppUsed eq 'Browser'"
#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`$filter=appId eq '00000002-0000-0ff1-ce00-000000000000' and clientAppUsed eq 'Browser' or clientAppUsed eq 'Mobile Apps and Desktop clients'"

#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`$filter=$exoModernAuthFilter"

#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`$filter=appId eq '00000002-0000-0ff1-ce00-000000000000' and clientAppUsed eq 'Exchange ActiveSync (unSupported)' or clientAppUsed eq 'Other clients' or clientAppUsed eq 'Other clients; IMAP' or clientAppUsed eq 'Other clients; MAPI' or clientAppUsed eq 'Other clients; Older Office clients' or clientAppUsed eq 'Other clients; POP' or clientAppUsed eq 'Other clients; SMTP'"
#$url = "https://graph.microsoft.com/beta/auditLogs/signIns?`$filter=appId eq '00000002-0000-0ff1-ce00-000000000000' and (clientAppUsed eq 'Exchange ActiveSync (unSupported)' or clientAppUsed eq 'Other clients' or clientAppUsed eq 'Other clients; IMAP' or clientAppUsed eq 'Other clients; MAPI' or clientAppUsed eq 'Other clients; Older Office clients' or clientAppUsed eq 'Other clients; POP' or clientAppUsed eq 'Other clients; SMTP' or clientAppUsed eq 'Browser')"





# By default, this script saves its results to DownloadedReport_currentTime.csv. You may change the file name as needed.
#$now = "{0:yyyyMMdd_hhmmss}" -f (get-date)
#$outputFile = "AAD_SignInReport_$now.csv"

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

#$displayName = 'jpoeppel-PS-test-public-client'
#$clientId = '7c5c030a-983f-4832-93df-b5a316971c20' # Client ID registered as public client
#$tenantId = 'eb81c4c9-2546-43f2-8c43-9c2295af4b88'
#$objectId = 'e2c6fd06-ca45-4fae-ac87-74bac46d38b5'
#$redirectUri = "urn:ietf:wg:oauth:2.0:oob"


$appManifestFile = 'jpoeppel-PS-test-public-client.json'


#needs relative path and error handling
$appManifestJson = Get-Content -Raw -Path $appManifestFile | ConvertFrom-Json

#$redirectUri = 'msal7c5c030a-983f-4832-93df-b5a316971c20://auth'

$MSGraphURI = "https://graph.microsoft.com"

#$tenantAuthority = "https://login.microsoftonline.com/$tenantId"
#$commonAuthority = "https://login.microsoftonline.com/common/"
$authority = "https://login.microsoftonline.com/"


if (!$token) {

    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
    $authResult = $authContext.AcquireToken($MSGraphURI, $clientId, $redirectUri, "Always")
    $token = $authResult.AccessToken
}


if ($null -eq $token) {
    Write-Output "ERROR: Failed to get an Access Token"
    exit
}

#Write-Output "--------------------------------------------------------------"
#Write-Output "Downloading report from $url"
#Write-Output "Output file: $outputFile"
#Write-Output "--------------------------------------------------------------"

# Call Microsoft Graph
$headers = Get-Headers($token)


<#
$count=0
$retryCount = 0
$oneSuccessfulFetch = $False



Do {
    #Write-Output "Fetching data using Url: $url"

    Try {
        $myReport = (Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri $url)
        $convertedReport = ($myReport.Content | ConvertFrom-Json).value
        
        #$convertedReport | Expand-Collections | ConvertTo-Csv -NoTypeInformation | Add-Content $outputFile
        $convertedReport #| select appDisplayName,clientAppUsed,createdDateTime,userPrincipalName,ipAddress,location
        #$convertedReport | select clientAppUsed
        
        $url = ($myReport.Content | ConvertFrom-Json).'@odata.nextLink'
        $count = $count+$convertedReport.Count
        #Write-Output "Total Fetched: $count"
        $oneSuccessfulFetch = $True
        $retryCount = 0
    }
    Catch [System.Net.WebException] {
        $statusCode = [int]$_.Exception.Response.StatusCode
        #Write-Output $statusCode
        #Write-Output $_.Exception.Message
        if($statusCode -eq 401 -and $oneSuccessfulFetch)
        {
            # Token might have expired! Renew token and try again
            $authResult = $authContext.AcquireToken($MSGraphURI, $clientId, $redirectUri, "Auto")
            $token = $authResult.AccessToken
            $headers = Get-Headers($token)
            $oneSuccessfulFetch = $False
        }
        elseif($statusCode -eq 429 -or $statusCode -eq 504 -or $statusCode -eq 503)
        {
            # throttled request or a temporary issue, wait for a few seconds and retry
            Start-Sleep -5
        }
        elseif($statusCode -eq 403 -or $statusCode -eq 401)
        {
            Write-Output "Error $statusCode - Please check the permissions of the user"
            break;
        }
        elseif($statusCode -eq 400)
        {
            Write-Output "Error $statusCode - There may have been zero results returned. Please check your filters"
            break;
        }
        else {
            if ($retryCount -lt 5) {
                Write-Output "Retrying..."
                $retryCount++
            }
            else {
                Write-Output "Download request failed. Please try again in the future."
                break
            }
        }
     }
    Catch {
        $exType = $_.Exception.GetType().FullName
        $exMsg = $_.Exception.Message

        Write-Output "Exception: $_.Exception"
        Write-Output "Error Message: $exType"
        Write-Output "Error Message: $exMsg"

         if ($retryCount -lt 5) {
            Write-Output "Retrying..."
            $retryCount++
        }
        else {
            Write-Output "Download request failed. Please try again in the future."
            break
        }
    }

    #Write-Output "--------------------------------------------------------------"
} while($url -ne $null)
#>






















<#

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