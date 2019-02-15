function Import-MCASCredential {
    [CmdletBinding()]
    param
    (
        # Specifies the app for which to retrieve the integer id value.
        [Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=0)]
        [ValidateNotNullOrEmpty()]
        $Path
    )
    process {
        Write-Verbose "Attempting to import MCAS credential from $Path"

        try {
            $importCred = Import-Clixml -Path $Path
        }
        catch {
            throw "The following error occurred when trying to import the credential object: $_"
        }

        #$pw = ConvertTo-SecureString -String ($imported.Password) -AsPlainText -Force

        $MCASCredential = New-Object -TypeName System.Management.Automation.PSCredential(($importCred.UserName),(ConvertTo-SecureString -String ($importCred.Password) -AsPlainText -Force)) 

        $MCASCredential
    }
}