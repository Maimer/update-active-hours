# Update Active Hours

Windows 10 Home does not allow users to shut off forced reboots that are caused by automatic updates. However, the user can set up to 12 Active Hours, during which the computer will not reboot. These scripts setup a scheduled task on the computer that runs every six hours daily. The scheduled task executes a powershell script that updates the registry values for the Active Hours start and end times so that the current time is always in Active Hours. This prevents the system from ever initiated a forced reboot.

### Usage

The first script `active_hours_scheduled_task.ps1` is used to create the scheduled task. The task itself runs the `update_active_hours.ps1` script when the task is executed.

The script has 3 possible parameters:

&nbsp;&nbsp;-taskName          The name of the scheduled task (Default: Update Active Hours)

&nbsp;&nbsp;-scriptLocation    The location of the script to schedule (Default: C:\update_active_hours.ps1)

&nbsp;&nbsp;-deleteTask        Flag to delete the named scheduled task

If the `update_active_hours.ps1` file is put into a custom location then the `-scriptLocation` parameter must be passed with the location of the script.

Default Example:

```powershell
PS C:\> . "C:\Path To Script\active_hours_scheduled_task.ps1"
```

Custom Example:

```powershell
PS C:\> . "C:\Path To Script\active_hours_scheduled_task.ps1" -taskName "My Custom Task" -scriptLocation "C:\My Custom Location\update_active_hours.ps1"
```
