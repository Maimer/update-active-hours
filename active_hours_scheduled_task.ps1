Param(
  [alias('n')]
  [string]$taskName,
  [alias('s')]
  [string]$scriptLocation,
  [alias('d')]
  [switch]$deleteTask,
  [alias('h')]
  [switch]$help
)

$TASK_NAME = "Update Active Hours"
$DEFAULT_LOCATION = "C:\update_active_hours.ps1"

function GetHelp {
  Write-Output "This script creates a scheduled task that runs every 6 hours to update the computer's Active Hours."
  Write-Output "Parameters:"
  Write-Output "  -TaskName          The name of the scheduled task (Default: ${TASK_NAME})"
  Write-Output "  -ScriptLocation    The location of the script to schedule (Default: ${DEFAULT_LOCATION})"
  Write-Output "  -DeleteTask        Flag to delete the named scheduled task"
  Write-Output "  -Help              Display help"
  Write-Output ""
}

if ($help) {
  GetHelp
  exit 0
}

if (!$taskName) {
  $taskName = $TASK_NAME
  Write-Output "Using Default Task Name: $taskName"
}

if (!$scriptLocation) {
  if (Test-Path -Path "${DEFAULT_LOCATION}") {
    $scriptLocation = $DEFAULT_LOCATION
    Write-Output "Using script in location: ${scriptLocation}"
  } else {
    Write-Output "Unable to locate script at ${DEFAULT_LOCATION}"
    Write-Output "Please move script to that location or specify location with -scriptLocation parameter."
    GetHelp
  }
} else {
  Write-Output "Using script in location: ${scriptLocation}"
}

$scheduledJob = SCHTASKS.exe /Query /TN "${taskName}" 2> $null
if ($deleteTask) {
  if ($scheduledJob) {
    SCHTASKS.exe /Delete /TN "${taskName}" /F
    Write-Output "${taskName} scheduled task deleted."
  } else {
    Write-Output "${taskName} scheduled task never enabled - no action taken."
    GetHelp
    Exit 0
  }
} else {
  if ($scheduledJob) {
    Write-Output "${taskName} scheduled task already exists - no action taken."
    Exit 0
  } else {
    Write-Output "Creating scheduled task: ${taskName}."
    SCHTASKS.exe /Create /RU "SYSTEM" /SC HOURLY /MO 6 /TN "${taskName}" `
    /TR "Powershell.exe -ExecutionPolicy Unrestricted -File ${scriptLocation}"
  }
}
