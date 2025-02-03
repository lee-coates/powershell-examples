# A Function to compare two strings and print out the result along with the Test name
function Write-TestResults
{
  param (
    [string]$TestLabel,
    [string]$ContentToTest,
    [string]$ExpectedResult
  )

  $TestPassOrFail = ($ContentToTest -eq $ExpectedResult)
  
  Write-Host "$TestLabel - Result: " -ForeGroundColor Black -BackgroundColor White -NoNewline
  
  Write-Host $(if ($TestPassOrFail) { "Pass" } else { "Fail" }) -BackgroundColor White -ForegroundColor $(if ($TestPassOrFail) { "Green" } else { "Red" }); if (-Not $TestPassOrFail) { Write-Host "  --> $($ContentToTest) <> $($ExpectedResult)" -BackgroundColor White -ForegroundColor Red }
}