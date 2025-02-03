if (Get-Module -Name RecordKeeper) { Remove-Module RecordKeeper }
Import-Module -Name "$PSScriptRoot\..\RecordKeeper.psd1"
. "$PSScriptRoot\Write-TestResults.ps1"

# Test 1: RecordKeeper created with no LogPath specified (default path in testoutput)
Function Test-New-RecordKeeper-1 {
    
    # Start by clearing the log (this is where the default log gets created)
    if (Test-Path -Path "RecordKeeper.log") { Remove-Item -Path "RecordKeeper.log" }

    $TestRecordKeeper1 = New-RecordKeeper -TaskName "Test-New-RecordKeeper-1"

    $ContentToTest = Get-Content -Path "RecordKeeper.log" -TotalCount 1 | Select-Object -Last 1

    Write-TestResults -TestLabel "Test 1: RecordKeeper created with the default LogPath" -ContentToTest $ContentToTest -ExpectedResult "$($TestRecordKeeper1.StartTime): Log for Test-New-RecordKeeper-1 started."
}

# Test 2: RecordKeeper created with LogPath passed as parameter
Function Test-New-RecordKeeper-2 {
    param (
        [string]$LogPath = "$PSScriptRoot\testoutput\Test-New-RecordKeeper.log"
    )
    
    # Clear previous test logs
    if (Test-Path -Path $LogPath) { Remove-Item -Path $LogPath }

    $TestRecordKeeper2 = New-RecordKeeper -LogPath $LogPath -TaskName "Test-New-RecordKeeper-2"

    $ContentToTest = Get-Content -Path $LogPath -TotalCount 1 | Select-Object -Last 1

    Write-TestResults -TestLabel "Test 2: RecordKeeper created with LogPath passed as parameter" -ContentToTest $ContentToTest -ExpectedResult "$($TestRecordKeeper2.StartTime): Log for Test-New-RecordKeeper-2 started."
}

Test-New-RecordKeeper-1
Test-New-RecordKeeper-2 -LogPath "$PSScriptRoot\testoutput\Test-New-RecordKeeper.log"