<#
    The MIT License (MIT)

    Copyright (c) 2016 QuietusPlus

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

function Invoke-ElevateScript {
    <#
    .SYNOPSIS
        Check if current session is elevated, if not restart process using -RunAs.

    .DESCRIPTION
        Place the following code at the top of your script, making sure "Invoke-ElevateScript.ps1" is within the same directory:

        . $PSScriptRoot\Invoke-ElevateScript.ps1
        Invoke-ElevateScript

        NOTE: Function only works on saved scripts. It also creates a new native PowerShell process, even if a script was launched using a third party alternative like cmder.

    .LINK
        https://github.com/QuietusPlus/Invoke-ElevateScript
    #>

    process {
        try {
            # Get current role and script path
            $currentRole = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
            $currentFile = $MyInvocation.PSCommandPath

            # Check if script path is empty, else check if not already elevated
            if ($currentFile -like $null) {
                Write-Error 'Failed to run command, $MyInvocation.PSCommandPath cannot be empty. Please make sure the source script has been saved to disk.'
            } elseif (-not $currentRole.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                # Launch current script in elevated PowerShell process + Exit current process
                Start-Process "$PSHome\powershell.exe" -Verb 'Runas' -ArgumentList "-NoExit -File $currentFile" -ErrorAction 'Stop'
                exit
            }
        } catch {
            throw
        }
    }
}
