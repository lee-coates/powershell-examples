# These Functions retrieve details about the processes using the most CPU


# If you need the information about remote computers, enter the list here; if left blank, the script assumes localhost
$ComputerName = @()

# The following command will get a snapshot of the 25 Processes using the most CPU
if ($ComputerName.Count = 0) 
{ 
    Get-Process | Sort-Object -Descending CPU | Select-Object -First 25 
}
else {
    foreach ($computer in $ComputerName.GetEnumerator())
    {
        Get-Process | Sort-Object -Descending CPU | Select-Object -First 25
    }
}


# Notice that the above command does not group processes by their ProcessName and does not produce a percentage breakdown like Task Manager does 
# The following command performs that grouping, sums the CPU Usage of the Group, and translates it into a total percentage
Get-Process | Group-Object Name | Sort-Object -Descending CPU | Select-Object -First 25