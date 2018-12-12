<#
.Synopsis
   Retrieves groups that are available for use in MCAS filters and policies.
.DESCRIPTION
   Get-MCASUserGroup gets groups that are available for use in MCAS filters and policies.

.EXAMPLE
   Get-MCASUserGroup

    PS C:\> Get-MCASUserGroup

    status                     : 0
    lastUpdatedTimestamp       : 1506613547015
    name                       : Office 365 administrator
    nameTemplate               : @{parameters=; template=SAGE_ADMIN_USERS_TAGS_GENERATOR_QUERY_BASED_USER_TAG_NAME}
    description                : Company administrators, user account administrators, helpdesk administrators, service
                                support administrators, and billing administrators
    descriptionTemplate        : @{template=SAGE_ADMIN_USERS_TAGS_GENERATOR_O365_DESCRIPTION}
    visibility                 : 0
    usersCount                 : 1
    source                     : @{addCondition=; removeCondition=; type=2; appId=11161}
    successfullyImportedBySage : True
    _tid                       : 26034820
    appId                      : 11161
    lastScannedBySage          : 1511881457181
    generatorType              : 0
    _id                        : 59cd1847321708f4acbe8c1f
    type                       : 2
    id                         : 59cd1847321708f4acbe8c1e
    target                     : 0

.FUNCTIONALITY
   Get-MCASUserGroup is intended to return the properties of the groups that are available for use in MCAS.
#>
function Get-MCASUserGroup {
    [CmdletBinding()]
    param (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -ge 0})]
        [int]$Skip = 0
    )

    $body = @{
        'skip'=$Skip
        'limit'=$ResultSetSize
    }

    # MAYBE ADD FILTERS IN FUTURE
    # "app":{"eq":[11161,20893,26055,15600,26324,20892,28375,11522]}

    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/user_tags/" -Body $body -Method Post
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data

    try {
        Write-Verbose "Adding alias property to results, if appropriate"
        $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
    }
    catch {}

    $response
}