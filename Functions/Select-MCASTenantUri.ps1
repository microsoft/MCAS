function Select-MCASTenantUri
{
    If ($TenantUri) {
        $TenantUri
        }
    ElseIf ($Credential) {
        $Credential.GetNetworkCredential().username
        }
    ElseIf ($CASCredential) {
        $CASCredential.GetNetworkCredential().username
        }
    Else {
        Write-Error 'No tenant URI available. Please check the -TenantUri parameter or username of the supplied credential' -ErrorAction Stop
        }
}
