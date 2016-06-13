$Passed = $True

#If (!(.\Invoke-CASModuleErrorTests.ps1)) {$Passed = $false}
If (!(.\Invoke-CASModuleResultCountTests.ps1)) {$Passed = $false}

If ($Passed) {Write-Host -ForegroundColor Green "All tests passed."}
Else {Write-Host -ForegroundColor Yellow "One or more tests failed!"}

Read-Host -Prompt 'Testing complete, press Enter to close'