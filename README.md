# Description

Check if current session is elevated, if not restart process using -RunAs.

# Instructions

Place the following code at the top of your script, making sure "Invoke-ElevateScript.ps1" is within the same directory:

```PowerShell
. $PSScriptRoot\Invoke-ElevateScript.ps1
Invoke-ElevateScript
```

# Notes

## Limitations

Invoke-ElevateScript only works on saved scripts.

## Alternative Consoles

Running the function will always start a native PowerShell process (if not yet elevated), even if it was launched using an alternative console like cmder.
