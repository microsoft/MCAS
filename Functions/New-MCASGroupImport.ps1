<#
.Synopsis
    New-MCASGroupImport is used to specify new Azure AD groups to import into Microsoft Cloud App Security. 
.DESCRIPTION
    User groups cannot be used to filter your data in MCAS until the group has been imported. This cmdlet allows you to pass in an Azure AD group object ID (GUID) to be imported. 
.EXAMPLE
    New-MCASGroupImport -GroupId '2fa66bee-8227-460a-8227-e72a70524d2d'
    
    This example passes in a single group ID to be imported. If successful, you will receive a unique identifier back as a response. If the group has already been imported, you will receive an error telling you the tag has already been imported.

.EXAMPLE
    $listOfGroups = ('a7052bee-8227-460a-8227-e72a70524d2d', 'e72a7bee-8227-460a-8227-e72a70524d2d'. '24d2dbee-8227-460a-8227-e72a70524d2d')    

    $listOfGroups | Foreach-Object {New-MCASGroupImport -GroupId $_}

    This example stores a list of group ID's in an array and then passes that list into the cmdlet through a foreach loop, importing all groups. This can be useful if you have a text file full of group ID's or if you plan to pull ID's programmatically from AAD via Graph API.
#>
function New-MCASGroupImport {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # The Azure AD Group ID (GUID) to be imported
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}$})]
        [string]$GroupId,

        # Set to $true if you wish to be notified after the group is imported. Default is $false
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateNotNullOrEmpty()]
        [boolean]$ShouldNotify = $false
    )
    
    try {
        $body = @{
            groupId = $groupId
            appId = 11161 #O365
            shouldNotify = $ShouldNotify
        }
        $response = Invoke-MCASRestMethod -Credential $Credential -body $body -Path "/cas/api/v1/user_tags/create_tag/" -Method Post 
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }
      
    $response
}