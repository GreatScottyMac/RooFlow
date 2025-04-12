#Requires -Version 5.0
<#
.SYNOPSIS
  Installs RooFlow configuration files by cloning the repository and copying necessary items.
.DESCRIPTION
  This script checks for Git, clones the RooFlow repository from GitHub to a temporary
  location, copies the '.roo' directory and '.roomodes' file to the current working
  directory, cleans up the temporary clone, and then runs the 'insert-variables.ps1'
  script to finalize the configuration.
.NOTES
  Author: Roo
  Date: 2025-04-12
  Based on the original install_rooflow.cmd script.
  Does not self-delete. The insert-variables.ps1 script is also preserved.
#>
param()

# Strict mode and error handling
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

Write-Host "--- Starting RooFlow config setup (PowerShell Version) ---"

# Define repository URL
$repoUrl = "https://github.com/GreatScottyMac/RooFlow"
# Define items to copy from the cloned repo's config directory
$itemsToCopy = @(
    @{ Source = '.roo'; Destination = '.roo'; IsDirectory = $true }
    @{ Source = '.roomodes'; Destination = '.roomodes'; IsDirectory = $false }
    @{ Source = 'insert-variables.ps1'; Destination = 'insert-variables.ps1'; IsDirectory = $false } # Add insert-variables.ps1 to copy list
)
# Current working directory where files will be copied
# Path to the variable insertion script in the target workspace (after copying)
# This avoids issues with $PSScriptRoot when using irm | iex

# --- Check for Git ---
Write-Host "Checking for Git..."
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if ($null -eq $gitPath) {
    Write-Error "Git is not found in your PATH."
    Write-Error "Please install Git and ensure it's added to your system's PATH."
    Write-Error "Download Git from: https://git-scm.com/download/win"
    exit 1
} else {
    Write-Host "Found Git executable: $($gitPath.Source)"
}

# --- Define and Create Temporary Directory ---
$tempCloneDir = Join-Path $env:TEMP "RooFlowClone_$(Get-Random)"
Write-Host "Cloning target temporary directory: $tempCloneDir"
if (Test-Path $tempCloneDir) {
    Write-Warning "Temporary directory '$tempCloneDir' already exists. Attempting to remove..."
    try {
        Remove-Item -Path $tempCloneDir -Recurse -Force
        Write-Host "  Removed existing temporary directory."
    } catch {
        Write-Error "Failed to remove existing temporary directory '$tempCloneDir'. Please remove it manually and retry. Error: $($_.Exception.Message)"
        exit 1
    }
}
# No need to explicitly create, git clone will do it.

# --- Clone Repository ---
Write-Host "Cloning RooFlow repository from $repoUrl..."
$cloneSuccess = $false
try {
    # Use -q for quieter output, remove if verbose output is needed
    git clone --depth 1 $repoUrl $tempCloneDir -q
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Repository cloned successfully."
        $cloneSuccess = $true
    } else {
        Write-Error "Git clone failed with exit code $LASTEXITCODE."
    }
} catch {
    Write-Error "An error occurred during git clone: $($_.Exception.Message)"
}

if (-not $cloneSuccess) {
    Write-Error "Failed to clone RooFlow repository. Check your internet connection and Git setup."
    # Attempt cleanup even on failure
    if (Test-Path $tempCloneDir) {
        Remove-Item -Path $tempCloneDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    exit 1
}

# --- Check Clone Integrity ---
$clonedConfigDir = Join-Path $tempCloneDir 'config'
if (-not (Test-Path $clonedConfigDir -PathType Container)) {
    Write-Error "RooFlow repository clone seems incomplete. Config directory not found in '$tempCloneDir'."
    if (Test-Path $tempCloneDir) {
        Remove-Item -Path $tempCloneDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    exit 1
}
Write-Host "  Clone integrity check passed (config directory found)."
$script:targetWorkspace = (Get-Location).Path # Define CWD just before copy, using script scope

# --- Copy Configuration Items ---
Write-Host "Copying specific configuration items to '$script:targetWorkspace'..."
$copyError = $false
foreach ($item in $itemsToCopy) {
    $sourcePath = Join-Path $clonedConfigDir $item.Source
    $destinationPath = Join-Path $script:targetWorkspace $item.Destination
    Write-Host "  Copying '$($item.Source)' to '$($item.Destination)'..."

    if (-not (Test-Path $sourcePath)) {
        Write-Error "  Source item '$($item.Source)' not found in cloned repository at '$sourcePath'."
        $copyError = $true
        continue # Skip to next item
    }

    try {
        if ($item.IsDirectory) {
            Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
        } else {
            Copy-Item -Path $sourcePath -Destination $destinationPath -Force
        }
        Write-Host "    Copied '$($item.Source)' successfully."
    } catch {
        Write-Error "  ERROR: Failed to copy '$($item.Source)'. Error: $($_.Exception.Message)"
        $copyError = $true
    }
}

# --- Check for Copy Errors ---
if ($copyError) {
    Write-Error "One or more essential files/directories could not be copied. Aborting setup."
    if (Test-Path $tempCloneDir) {
        Write-Host "Cleaning up temporary directory after copy error..."
        Remove-Item -Path $tempCloneDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    exit 1
}
Write-Host "  All required items copied successfully."

# --- Cleanup Temporary Directory ---
Write-Host "Cleaning up temporary clone directory '$tempCloneDir'..."
if (Test-Path $tempCloneDir) {
    try {
        Remove-Item -Path $tempCloneDir -Recurse -Force
        Write-Host "  Removed temporary clone directory."
    } catch {
        Write-Warning "Failed to completely remove temporary clone directory '$tempCloneDir'. Error: $($_.Exception.Message)"
        # Continue execution as the main goal was achieved
    }
} else {
    Write-Host "  Temporary clone directory not found, no cleanup needed."
}

# --- Check Essential Copied Items ---
Write-Host "Verifying copied items in '$script:targetWorkspace'..."
$verificationFailed = $false
foreach ($item in $itemsToCopy) {
    $destinationPath = Join-Path $script:targetWorkspace $item.Destination
    if (-not (Test-Path $destinationPath)) {
        Write-Error "Verification failed: '$($item.Destination)' not found in '$script:targetWorkspace' after copy."
        $verificationFailed = $true
    }
}
if ($verificationFailed) {
    Write-Error "Essential items missing after copy. Setup failed."
    exit 1
}
Write-Host "  Copied items verified successfully."
$script:insertScriptPath = Join-Path $script:targetWorkspace 'insert-variables.ps1' # Define script path just before run, using script scope

# --- Run Insert Variables Script ---
Write-Host "Running insert-variables.ps1 script..."
if (-not (Test-Path $script:insertScriptPath -PathType Leaf)) {
     Write-Error "Cannot find the script '$script:insertScriptPath' to run variable insertion."
     exit 1
}

try {
    # Execute the script. Use -File parameter for safety.
    # Use Invoke-Command or call operator & if needed, but direct execution should work if in PATH or using full path.
    # Using Call operator & for robustness
    & $script:insertScriptPath
    if ($LASTEXITCODE -ne 0) {
        # Error message should be printed by insert-variables.ps1 itself
        Write-Error "'$script:insertScriptPath' script reported an error (Exit Code: $LASTEXITCODE)."
        exit 1 # Propagate the error
    } else {
        Write-Host "'$script:insertScriptPath' completed successfully."
    }

# --- Clean up insert-variables.ps1 ---
Write-Host "Removing '$($script:insertScriptPath)'..."
try {
    if (Test-Path $script:insertScriptPath -PathType Leaf) {
        Remove-Item -Path $script:insertScriptPath -Force -ErrorAction Stop
        Write-Host "  Successfully removed '$($script:insertScriptPath)'."
    } else {
        # This case shouldn't happen if the script just ran successfully, but good to handle.
        Write-Warning "  '$($script:insertScriptPath)' was not found for removal, though it should have just executed."
    }
} catch {
    Write-Warning "Failed to remove '$($script:insertScriptPath)'. You may need to delete it manually. Error: $($_.Exception.Message)"
}

} catch {
    Write-Error "An error occurred while trying to execute '$script:insertScriptPath': $($_.Exception.Message)"
    exit 1
}

Write-Host "--- RooFlow config setup complete ---"

# Self-deletion logic removed to avoid issues with iex execution context


$null # Attempt to clear final state for iex
exit 0