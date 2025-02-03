if (Get-Module -Name RecordKeeper) { Remove-Module RecordKeeper }
Import-Module -Name "$PSScriptRoot\..\RecordKeeper.psd1"
. "$PSScriptRoot\Write-TestResults.ps1"

function Test-RecordKeeper() {
    param (
        [string] $LogPath = "$PSScriptRoot\testoutput\Test-RecordKeeper.log"
    )

    # Start by clearing the test log
    if (Test-Path -Path $LogPath) { Remove-Item -Path $LogPath }

    # Test 1: Test New-RecordKeeper
    $TransferRecordKeeper = New-RecordKeeper -LogPath $LogPath -TaskName "Test-RecordKeeper"
    $ContentToTest = Get-Content -Path $LogPath -TotalCount 1 | Select-Object -Last 1
    Write-TestResults -TestLabel "Test 1: Start the Record Keeper" -ContentToTest $ContentToTest -ExpectedResult "$($TransferRecordKeeper.StartTime): Log for Test-RecordKeeper started."
    
    # Test 2: AddToLog
    $TransferRecordKeeper.AddToLog("Test Record.")
    $ContentToTest = (Get-Content -Path $LogPath -TotalCount 2 | Select-Object -Last 1).Split(': ')[1].TrimStart()
    Write-TestResults -TestLabel "Test 2: Add to the Record Keeper" -ContentToTest $ContentToTest -ExpectedResult "Test Record." 
    
    # Test 3: IncreaseRecordCounter with a success
    $TransferRecordKeeper.IncreaseRecordCounter($true)
    $TransferRecordKeeper.AddToLog($TransferRecordKeeper.TotalSuccessfulRecords)
    $ContentToTest = (Get-Content -Path $LogPath -TotalCount 3 | Select-Object -Last 1).Split(': ')[1].TrimStart()
    Write-TestResults -TestLabel "Test 3: IncreaseRecordCounter with a success" -ContentToTest $ContentToTest -ExpectedResult "1"
    
    # Test 4: IncreaseRecordCounter with a failure
    $TransferRecordKeeper.IncreaseRecordCounter($false)
    $TransferRecordKeeper.AddToLog($TransferRecordKeeper.TotalSuccessfulRecords)
    $ContentToTest = (Get-Content -Path $LogPath -TotalCount 4 | Select-Object -Last 1).Split(': ')[1].TrimStart()
    Write-TestResults -TestLabel "Test 4: IncreaseRecordCounter with a failure" -ContentToTest $ContentToTest -ExpectedResult "1"

    # Test 5: IncreaseRecordCounter Total Records
    $TransferRecordKeeper.AddToLog($TransferRecordKeeper.TotalRecords)
    $ContentToTest = (Get-Content -Path $LogPath -TotalCount 5 | Select-Object -Last 1).Split(': ')[1].TrimStart()
    Write-TestResults -TestLabel "Test 5: IncreaseRecordCounter Total Records" -ContentToTest $ContentToTest -ExpectedResult "2"

    # Test 6: End the Record Keeper
    $TransferRecordKeeper.EndLog()
    $ContentToTest = Get-Content -Path $LogPath -TotalCount 6 | Select-Object -Last 1
    Write-TestResults -TestLabel "Test 6: End the Record Keeper" -ContentToTest $ContentToTest -ExpectedResult "Test-RecordKeeper record keeping complete. 2 records processed with 1 successes and 1 errors for a duration of 00:00:00"
}

Test-RecordKeeper