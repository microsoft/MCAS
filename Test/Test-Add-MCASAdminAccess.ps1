Add-MCASAdminAccess -UserName ($AdminTestUsers[0].username) -PermissionType READ_ONLY
Add-MCASAdminAccess -UserName ($AdminTestUsers[1].username) -PermissionType FULL_ACCESS

Describe 'Add-MCASAdminAccess' {
    It 'Adds a non-admin user to the list of READ_ONLY MCAS admins' {        
        Add-MCASAdminAccess -UserName ($AdminTestUsers[0].username) -PermissionType READ_ONLY

        (Get-MCASAdmin | Where-Object {$_.username -eq ($AdminTestUsers[0].username)}).permission_type -eq 'READ_ONLY' | Should Be $true
    }
    It 'Adds a non-admin user to the list of FULL_ACCESS MCAS admins' {       
        Add-MCASAdminAccess -UserName ($AdminTestUsers[1].username) -PermissionType READ_ONLY

        (Get-MCASAdmin | Where-Object {$_.username -eq ($AdminTestUsers[1].username)}).permission_type -eq 'FULL_ACCESS' | Should Be $true
    }
}