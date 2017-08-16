<#
.Synopsis
   Gets a credential to be used by other Cloud App Security module cmdlets.
.DESCRIPTION
   Get-MCASCredential imports a set of credentials to be used by other Cloud App Security module cmdlets.

   When using Get-MCASCredential you will be prompted to provide your Cloud App Security tenant URL as well as an OAuth Token that must be created manually in the console.

   Get-MCASCredential takes the tenant URL and OAuth token and stores them in a special global session variable called $CASCredential and converts the OAuth token to a 64bit secure string while in memory.

   All CAS Module cmdlets reference that special global variable to pass requests to your Cloud App Security tenant.

   See the examples section for ways to automate setting your CAS credentials for the session.

.EXAMPLE
   Get-MCASCredential

    This prompts the user to enter both their tenant URL as well as their OAuth token.

    Username = Tenant URL without https:// (Example: contoso.portal.cloudappsecurity.com)
    Password = Tenant OAuth Token (Example: 432c1750f80d66a1cf2849afb6b10a7fcdf6738f5f554e32c9915fb006bd799a)

    C:\>$CASCredential

    To verify your credentials are set in the current session, run the above command.

    UserName                                 Password
    --------                                 --------
    contoso.portal.cloudappsecurity.com    System.Security.SecureString

.EXAMPLE
    Get-MCASCredential -PassThru | Export-CliXml C:\Users\Alice\MyCASCred.credential -Force

    By specifying the -PassThru switch parameter, this will put the $CASCredential into the pipeline which can be exported to a .credential file that will store the tenant URL and encrypted version of the token in a file.

    We can use this newly created .credential file to automate setting our CAS credentials in the session by adding an import command to our profile.

    C:\>notepad $profile

    The above command will open our PowerShell profile, which is a set of commands that will run when we start a new session. By default it is empty.

    $CASCredential = Import-Clixml "C:\Users\Alice\MyCASCred.credential"

    By adding the above line to our profile and save, the next time we open a new PowerShell session, the credential file will automatically be imported into the $CASCredential which allows us to use other CAS cmdlets without running Get-MCASCredential at the start of the session.

.FUNCTIONALITY
   Get-MCASCredential is intended to import the CAS tenant URL and OAuth Token into a global session variable to allow other CAS cmdlets to authenticate when passing requests.
#>
function Get-MCASCredential
{
    [CmdletBinding()]
    [Alias('Get-CASCredential')]
    [OutputType([System.Management.Automation.PSCredential])]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies that the credential should be returned into the pipeline for further processing.
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    )
    Process
    {
        # If tenant URI is specified, prompt for OAuth token and get it all into a global variable
        If ($TenantUri) {
            [System.Management.Automation.PSCredential]$Global:CASCredential = Get-Credential -UserName $TenantUri -Message "Enter the OAuth token for $TenantUri"
        }

        # Else, prompt for both the tenant and OAuth token and get it all into a global variable
        Else {
            [System.Management.Automation.PSCredential]$Global:CASCredential = Get-Credential -Message "Enter the CAS tenant and OAuth token"
        }

        # If -PassThru is specified, write the credential object to the pipeline (the global variable will also be exported to the calling session with Export-ModuleMember)
        If ($PassThru) {
            $CASCredential
        }
    }
}
