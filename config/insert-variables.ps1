#Requires -Version 5.0
<#
.SYNOPSIS
  Replaces placeholder variables in RooFlow system prompt files.
.DESCRIPTION
  This script retrieves system information (OS, Shell, Home Directory, Workspace)
  and replaces corresponding placeholders (OS_PLACEHOLDER, SHELL_PLACEHOLDER,
  HOME_PLACEHOLDER, WORKSPACE_PLACEHOLDER) in all 'system-prompt-*' files
  located within the '.roo' directory relative to the current working directory.
.NOTES
  Author: Roo
  Date: 2025-04-12
  Based on the original insert-variables.cmd script.
#>
param()

# Strict mode and error handling
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

Write-Host "--- Starting variable insertion ---"

try {
    # --- Get Environment Variables ---
    Write-Host "Gathering environment information..."
    $os = (Get-CimInstance Win32_OperatingSystem).Caption.Trim()
    $shell = 'cmd' # Keep consistent with original script's logic for replacement
    $homeDir = $env:USERPROFILE
    $workspace = (Get-Location).Path # Current working directory

    Write-Host "  OS: $os"
    Write-Host "  Shell (for replacement): $shell"
    Write-Host "  Home: $homeDir"
    Write-Host "  Workspace: $workspace"

    # --- Directory Setup ---
    $rooDir = Join-Path $workspace '.roo'
    Write-Host "Target .roo directory: $rooDir"

    # Check if the .roo directory exists
    if (-not (Test-Path $rooDir -PathType Container)) {
        Write-Error ".roo directory not found in '$workspace'. Please ensure the directory exists."
        exit 1 # Exit with a non-zero code to indicate failure
    }

    # --- Execute File Content Replacement ---
    Write-Host "Processing system prompt files in '$rooDir'..."
    $files = Get-ChildItem -Path $rooDir -Filter 'system-prompt-*' -File -ErrorAction SilentlyContinue

    if ($null -eq $files -or $files.Count -eq 0) {
         Write-Warning "No 'system-prompt-*' files found in '$rooDir'. No variables inserted."
         # Exit successfully as there's nothing to process
         Write-Host "--- Variable insertion finished (no files found) ---"
         exit 0
    }

    foreach ($file in $files) {
        Write-Host "  Processing: $($file.FullName)"
        $content = Get-Content $file.FullName -Raw
        $originalContent = $content # Keep a copy for comparison if needed

        # Perform replacements
        $content = $content -replace 'OS_PLACEHOLDER', $os
        $content = $content -replace 'SHELL_PLACEHOLDER', $shell
        $content = $content -replace 'HOME_PLACEHOLDER', $homeDir
        $content = $content -replace 'WORKSPACE_PLACEHOLDER', $workspace

        # Write back only if content changed (optional optimization)
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8 # Specify encoding
            Write-Host "    Completed replacement in: $($file.Name)"
        } else {
            Write-Host "    No changes needed for: $($file.Name)"
        }
    }

    Write-Host "--- Variable insertion completed successfully ---"
    exit 0

} catch {
    Write-Error "An error occurred during variable insertion: $($_.Exception.Message)"
    # Write-Error $_.ScriptStackTrace # Uncomment for detailed stack trace
    exit 1
}