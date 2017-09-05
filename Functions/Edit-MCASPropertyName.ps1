function Edit-MCASPropertyName
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ResponseData,    
    
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$OldPropName,

        [Parameter(Mandatory=$true, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$NewPropName
    )

    # Patch for property name collisions
    If (Select-String -InputObject $ResponseData -Pattern $OldPropName -CaseSensitive -Quiet) {
        Write-Verbose "A property name collision was detected in the response from MCAS for the following property names: $OldPropName and $NewPropName. The $OldPropName property will be renamed to $NewPropName."
        $ResponseData.Replace($OldPropName, $NewPropName)  
    }
}