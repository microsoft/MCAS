﻿function Invoke-MCASRestMethod {
    [CmdletBinding()]
    param (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com' for Commercial) and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                ($_.GetNetworkCredential().username).EndsWith('.portal.cloudappsecurity.com') -or ($_.GetNetworkCredential().username).EndsWith('.portal.cloudappsecurity.us')
            })]
        [ValidateScript( {
                $_.GetNetworkCredential().Password -match ($MCAS_TOKEN_VALIDATION_PATTERN)
            })]
        [System.Management.Automation.PSCredential]$Credential,

        # Specifies the relative path of the full uri being invoked (e.g. - '/api/v1/alerts/')
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                $_.StartsWith('/')
            })]
        [string]$Path,

        # Specifies the HTTP method to be used for the request
        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
        [string]$Method,

        # Specifies the body of the request, not including MCAS query filters, which should be specified separately in the -FilterSet parameter
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Body,

        # Specifies the content type to be used for the request
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ContentType = 'application/json',

        # Specifies the MCAS query filters to be used, which will be added to the body of the message
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        $FilterSet,

        # Specifies the retry interval, in seconds, if a call to the MCAS web API is throttled. Default = 5 (seconds)
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$RetryInterval = 5,

        # Specifies that a single item is to be fetched, skipping any processing for lists, such as checking result count totals
        #[switch]$Fetch,

        # Specifies use Invoke-WebRequest instead of Invoke-RestMethod, enabling the caller to get the raw response from the MCAS API without any JSON conversion
        [switch]$Raw
    )
    #Ensure TLS 1.2 is used.
    if([Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls12'){
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    if ($Raw) {
        $cmd = 'Invoke-WebRequest'
        Write-Verbose "-Raw parameter was specified"
    }
    else {
        $cmd = 'Invoke-RestMethod'
        Write-Verbose "-Raw parameter was not specified"
    }
    Write-Verbose "$cmd will be used"

    $tenant = ($Credential.GetNetworkCredential().username)
    Write-Verbose "Tenant name is $tenant"

    Write-Verbose "Relative path is $Path"

    Write-Verbose "Method is $Method"

    $token = $Credential.GetNetworkCredential().Password
    #MK - Commenting out this line for security reasons. Not sure I like having the raw token in the verbose output.
    #Write-Verbose "OAuth token is $token"

    $headers = 'Authorization = "Token {0}"' -f $token | ForEach-Object {
        "@{$_}"
    }

    $verboseHeaders = $headers -replace 'Authorization = "Token .{9}', 'Authorization = "Token XXXXXXXXX'

    Write-Verbose "Request headers are $verboseHeaders"

    # Construct base MCAS call before processing -Body and -FilterSet
    $mcasCall = '{0} -Uri ''https://{1}{2}'' -Method {3} -Headers {4} -ContentType {5} -UseBasicParsing' -f $cmd, $tenant, $Path, $Method, $headers, $ContentType

    if ($Method -eq 'Get') {
        Write-Verbose "A request using the Get HTTP method cannot have a message body."
    }
    else {
        $jsonBody = $Body | ConvertTo-Json -Compress -Depth 4
        Write-Verbose "Base request body is $jsonBody"

        if ($FilterSet) {
            Write-Verbose "Request body before query filters is $jsonBody"
            $jsonBody = $jsonBody.TrimEnd('}') + ',' + '"filters":{' + ((ConvertTo-MCASJsonFilterString $FilterSet).TrimStart('{')) + '}'
            Write-Verbose "Request body after query filters is $jsonBody"
        }
        else {
            Write-Verbose "No filters were added to the request body"
        }
        Write-Verbose "Final request body is $jsonBody"

        # Add -Body to the constructed MCAS call, when the http method is not 'Get'
        $mcasCall = '{0} -Body ''{1}''' -f $mcasCall, $jsonBody
    }

    Write-Verbose "Constructed call to MCAS is to follow:"
    $mcasCall2 = '{0} -Uri ''https://{1}{2}'' -Method {3} -ContentType {5} -UseBasicParsing' -f $cmd, $tenant, $Path, $Method, $headers, $ContentType

    Write-Verbose $mcasCall2

    Write-Verbose "Retry interval if MCAS call is throttled is $RetryInterval seconds"

    # This loop is the actual call to MCAS. It includes automatic retry if the API call is throttled
    do {
        $retryCall = $false

        try {
            Write-Verbose "Attempting call to MCAS..."
            $response = Invoke-Expression -Command $mcasCall
        }
        catch {
            if ($_ -like 'The remote server returned an error: (429) TOO MANY REQUESTS.') {
                Write-Warning "429 - Too many requests. The MCAS API throttling limit has been hit, the call will be retried in $RetryInterval second(s)..."
                $retryCall = $true
                Write-Verbose "Sleeping for $RetryInterval seconds"
                Start-Sleep -Seconds $RetryInterval
            }
            ElseIf ($_ -match 'throttled') {
                Write-Warning "Too many requests. Usually the throttle time for this call is 1 minute. Next request will resume in 1 minute..."
                $retryCall = $true
                Write-Verbose "Sleeping for 60 seconds"
                Start-Sleep -Seconds 60
            }
            ElseIf ($_ -like '504' -or $_ -like '502') {
                Write-Warning "502 or 504 error encountered. The call will be retried in $RetryInterval second(s)..."
                $retryCall = $true
                Write-Verbose "Sleeping for $RetryInterval seconds"
                Start-Sleep -Seconds $RetryInterval
            }
            else {
                throw $_
            }
        }

        # Uncomment following two lines if you want to see raw responses in -Verbose output
        #Write-Verbose 'MCAS response to follow:'
        #Write-Verbose $response
    }
    while ($retryCall)

    # Provide the total record count in -Verbose output and as InformationVariable, if appropriate
    if (@('Get', 'Post') -contains $Method) {
        if ($response.total) {
            Write-Verbose 'Checking total matching record count via the response properties...'
            $recordTotal = $response.total
        }
        elseif ($response.Content) {
            try {
                Write-Verbose 'Checking total matching record count via raw JSON response...'
                $recordTotal = (($response.content).Replace('"Level":','"Level_2":') | ConvertFrom-Json).total
            }
            catch {
                Write-Verbose 'JSON conversion failed. Checking total matching record count via raw response string extraction...'
                #below linew as commented out as it breaks with the new activities_kusto endpoint.
                #$recordTotal = ($response.Content.Split(',', 3) | Where-Object {$_.StartsWith('"total"')} | Select-Object -First 1).Split(':')[1]
            }
        }
        else {
            Write-Verbose 'Could not check total matching record count, perhaps because zero or one records were returned. Zero will be returned as the matching record count.'
            $recordTotal = 0
        }

        Write-Verbose ('The total number of matching records was {0}' -f $recordTotal)
        #removing the below line because it is now breaking certain cmdlets such as Get-MCASFile when retriving a file by identity
        #Write-Information $recordTotal
    }
    $response
}
