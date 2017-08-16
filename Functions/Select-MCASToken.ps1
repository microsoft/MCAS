function Select-MCASToken
{
    If ($Credential) {
        $Credential.GetNetworkCredential().Password.ToLower()
        }
    ElseIf ($CASCredential) {
        $CASCredential.GetNetworkCredential().Password.ToLower()
        }
    Else {
        Write-Error 'No token available. Please check the OAuth token (password) of the supplied credential' -ErrorAction Stop
        }
}
