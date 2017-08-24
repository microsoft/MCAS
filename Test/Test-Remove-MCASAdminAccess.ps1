Describe 'Remove-MCASAdminAccess' {
    It 'Removes a user from the list of READ_ONLY MCAS admins' {        
        Remove-MCASAdminAccess -UserName ($AdminTestUsers[0].username) 

        Start-Sleep -Seconds 3

        (Get-MCASAdminAccess).username -contains  ($AdminTestUsers[0].username) | Should Be $false
    }
    It 'Removes a user from the list of FULL_ACCESS MCAS admins' {       
        Remove-MCASAdminAccess -UserName ($AdminTestUsers[1].username)

        Start-Sleep -Seconds 3
        
        (Get-MCASAdminAccess).username -contains  ($AdminTestUsers[1].username) | Should Be $false
    }
}