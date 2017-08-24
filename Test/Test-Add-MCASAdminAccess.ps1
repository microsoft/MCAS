Describe 'Add-MCASAdminAccess' {
    It 'Adds a user to the list of READ_ONLY MCAS admins' {        
        Add-MCASAdminAccess -UserName $AdminTestUsers[0] -PermissionType READ_ONLY

        Start-Sleep -Seconds 3

        (Get-MCASAdminAccess | Where-Object {$_.username -eq $AdminTestUsers[0]}).permission_type -eq 'READ_ONLY' | Should Be $true
    }
    It 'Adds a user to the list of FULL_ACCESS MCAS admins' {       
        Add-MCASAdminAccess -UserName $AdminTestUsers[1] -PermissionType FULL_ACCESS
        
        Start-Sleep -Seconds 3

        (Get-MCASAdminAccess | Where-Object {$_.username -eq $AdminTestUsers[1]}).permission_type -eq 'FULL_ACCESS' | Should Be $true
    }
}