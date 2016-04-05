#--------------------------------------------------------------------------------- 

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Bypass","Restricted","AllSigned","RemoteSigned","Unrestricted")]
        [System.String]
        $ExecutionPolicy
    )
    
    #Gets the execution policies for the current session.
    $returnValue = @{ExecutionPolicy = $(Get-ExecutionPolicy)}

    $returnValue
}


function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Bypass","Restricted","AllSigned","RemoteSigned","Unrestricted")]
        [System.String]
        $ExecutionPolicy
    )
    
    If($PSCmdlet.ShouldProcess("$ExecutionPolicy","Set-ExecutionPolicy"))
    {
        Try
        {
            Write-Verbose "Setting the execution policy of PowerShell."
            Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Force -ErrorAction Stop
        }
        Catch
        {
            if($_.toString() -like "Windows PowerShell updated your execution policy successfully*")    # trap this error, it set correctlly.
            {
                Write-Verbose "$_"
            }
            else
            {
                throw
            }
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Bypass","Restricted","AllSigned","RemoteSigned","Unrestricted")]
        [System.String]
        $ExecutionPolicy
    )

    If($(Get-ExecutionPolicy) -eq $ExecutionPolicy)
    {
        return $true
    }
    else
    {
        return $false
    }
}

Export-ModuleMember -Function *-TargetResource
