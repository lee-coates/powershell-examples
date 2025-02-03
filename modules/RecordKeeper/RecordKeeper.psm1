# This class is used to keep track and log transfer progress
class RecordKeeper {
    [string] $LogPath
    [DateTime] $StartTime
    [int] $TotalRecords
    [int] $TotalSuccessfulRecords
    [int] $TotalErrorRecords
    [string] $TaskName
  
    # constructor will run when the RecordKeeper object is created
    RecordKeeper([string] $LogPath, [string] $TaskName){
      $this.LogPath = $LogPath
      $this.StartTime = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
      $this.TotalRecords = 0
      $this.TotalSuccessfulRecords = 0
      $this.TotalErrorRecords = 0
      $this.TaskName = $TaskName
  
      Add-Content -Path $this.LogPath -Value "$($this.StartTime): Log for $TaskName started."
    }
    
    [void] AddToLog([string]$logRecord) {
      Add-Content -Path $this.LogPath -Value "$(Get-Date -Format "MM/dd/yyyy HH:mm:ss"): $logRecord"
    }
    
    [void] IncreaseRecordCounter([bool]$recordSuccess) {
      if ($recordSuccess -eq $true) {
        $this.TotalSuccessfulRecords++
      }
      else {
        $this.TotalErrorRecords++
      }
      
      $this.TotalRecords++
    }
  
    [void] EndLog() {
      Add-Content -Path $this.LogPath -Value "$($this.TaskName) record keeping complete. $($this.TotalRecords) records processed with $($this.TotalSuccessfulRecords) successes and $($this.TotalErrorRecords) errors for a duration of $(New-TimeSpan -Start $this.StartTime -End (get-date -Format "MM/dd/yyyy HH:mm:ss"))"
    }
}

Function New-RecordKeeper
{
    param (
        [string] $LogPath,
        [string] $TaskName = "No Task Specified"
    )

    # if there is no LogPath, create the log wherever the function was called
    if ($LogPath.Length -eq 0)
    {
      return [RecordKeeper]::new("RecordKeeper.log", $TaskName)
    }
    else 
    {
      # if a path was specified, ensure that folder exists
      $LogDirectory = [System.IO.Path]::GetDirectoryName($LogPath)
      if (-not (Test-Path $LogDirectory)) {
          New-Item -ItemType Directory -Path $LogDirectory
      }
      if (Test-Path $LogPath) {
          return [RecordKeeper]::new($LogPath, $TaskName)
      }
      
      return [RecordKeeper]::new($LogPath, $TaskName)
    }
}