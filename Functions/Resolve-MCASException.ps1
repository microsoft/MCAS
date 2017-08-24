function Resolve-MCASException {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        $MCASException
    )
     
    If ($MCASException -like 'The remote server returned an error: (404) Not Found.') {
        '404 - Not Found. Check to ensure the -Identity and -TenantUri parameters are valid.'
    }
    ElseIf ($MCASException -like "The remote server returned an error: (403) Forbidden.") {
        '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified token is valid.'
    }
    ElseIf ($MCASException -match 'The remote name could not be resolved: ') {
        'The remote name could not be resolved. Check to ensure the -TenantUri parameter is valid.'
    }
    ElseIf ($MCASException -like 'The remote server returned an error: (429) TOO MANY REQUESTS.') {
       '429 - Too many requests. Do not exceed 30 requests/min. Please wait and try again.'
    }
    Else {
        'Unknown exception when attempting to contact the Cloud App Security REST API'
    }
}
    