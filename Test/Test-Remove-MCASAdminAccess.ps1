Describe 'Remove-MCASAdminAccess' {
    It 'Removes an admin user from the list of READ_ONLY MCAS admins' {        
        Remove-MCASAdminAccess -UserName ($AdminTestUsers[0].username) 

        (Get-MCASAdminAccess).username -contains  ($AdminTestUsers[0].username) | Should Be $false
    }
    It 'Removes an admin user from the list of FULL_ACCESS MCAS admins' {       
        Remove-MCASAdminAccess -UserName ($AdminTestUsers[1].username)

        (Get-MCASAdminAccess).username -contains  ($AdminTestUsers[1].username) | Should Be $false
    }
}