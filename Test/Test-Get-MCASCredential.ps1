
# Call Get-MCASCredential, if no credential is available in the session
If (($null -eq $CASCredential) -or !($CASCredential)) {
    Get-MCASCredential
    }

# Test Get-MCASCredential (interaction required)
If ($RunInteractiveTests) {
    Describe 'Get-MCASCredential' {
        It 'Outputs a credential object when -PassThru is used' {
            (Get-MCASCredential -PassThru | Get-TypeData).TypeName | Should Be 'System.Management.Automation.PSCredential'
        }

        It 'Properly accepts -TenantUri as specified by the user' {
            (Get-MCASCredential -PassThru -TenantUri 'contoso.portal.cloudappsecurity.com').GetNetworkCredential().username | Should Be 'contoso.portal.cloudappsecurity.com'
        }
    }
}