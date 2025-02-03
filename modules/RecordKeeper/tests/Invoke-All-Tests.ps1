# The purpose of this function is to run all of the tests at once

function Invoke-All-Tests {
    Write-Host "Running all tests..."
    Get-ChildItem -Path "$PSScriptRoot\*.ps1" -Include Test* -File -Recurse | ForEach-Object { 
        Write-Host "Now Testing $($_.Name)"
        & $_.FullName
    }
}

Invoke-All-Tests