
#----------------------------Includes---------------------------
# KUDOS to the chocolatey project for the basis of this code

# get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)

#find all the ps1 files in the subfolder functions
Resolve-Path -Path $mypath\functions\*.ps1 | ForEach-Object -Process {
    . $_.ProviderPath
    $Function = ((Split-Path -Path $_.ProviderPath -Leaf).Split('.')[0])   
}


#----------------------------Exports---------------------------
# Cmdlets to export (must be exported as functions, not cmdlets)

$ExportedCommands = @('Add-MCASAdminAccess','Export-MCASBlockScript','Get-MCASAdminAccess','Get-MCASAccount','Get-MCASActivity','Get-MCASAlert','Get-MCASAppInfo','Get-MCASCredential','Get-MCASDiscoveredApp','Get-MCASFile','Get-MCASGovernanceLog','Get-MCASReport','Get-MCASStream','Remove-MCASAdminAccess','Send-MCASDiscoveryLog','Set-MCASAlert')

$ExportedCommands | ForEach-Object {Export-ModuleMember -Function $_}

Export-ModuleMember -Function Invoke-MCASRestMethod


# Vars to export (must be exported here, even if also included in the module manifest in 'VariablesToExport'
Export-ModuleMember -Variable CASCredential

# Aliases to export
Export-ModuleMember -Alias *
