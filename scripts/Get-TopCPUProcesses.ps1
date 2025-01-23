Function Get-TopCPUProcesses {
    <#
    .SYNOPSIS
    This Function retrieves details about the processes using the most CPU

    .DESCRIPTION
    A more detailed description of the function and its purpose.

    .PARAMETER ComputerName
    The ComputerName parameter can be used to provide a list of computer names to get the processes from; the default is localhost

    .PARAMETER NumberOfProcesses
    The NumberOfProcesses parameter can be used to limit the number top processes returned; the default is 25

    .EXAMPLE
    Get-TopCPUProcesses -ComputerName "ComputerName1", "ComputerName2"

    .NOTES
    This function returns data grouped by process name, summing cpu usage
    #>
    param (
        [string[]]$ComputerName,
        [int]$NumberOfProcesses = 25
    )

    # Check if the parameter has been passed
    if ($ComputerName.Count -eq 0) 
    { 
        Get-Process | Group-Object Name | Sort-Object -Descending CPU | Select-Object -First $NumberOfProcesses
    }
    else {
        foreach ($computer in $ComputerName.GetEnumerator())
        {
            Write-Host $computer
            $results = Invoke-Command -ComputerName $computer -ScriptBlock { 
                param (
                    [int]$NumberOfProcesses
                )
                return Get-Process | Group-Object Name | Sort-Object -Descending CPU | Select-Object -First $NumberOfProcesses | Out-String
            }
            
            Write-Host $results
        }
    }

}