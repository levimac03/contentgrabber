# Determine the directory to work with.
$targetDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }

$outputFile = Join-Path -Path $targetDir -ChildPath "File contents.txt"

# Get the script's name if running as a script; otherwise, leave empty.
$scriptName = if ($PSCommandPath) { [System.IO.Path]::GetFileName($PSCommandPath) } else { "" }

# Clear the output file if it exists
if (Test-Path $outputFile) {
    Clear-Content $outputFile
}

# Define image file extensions to exclude (all in lowercase for consistency)
$imageExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".svg", ".webp")

# Get all files in the target directory excluding the script itself, the output file, and any image files.
$files = Get-ChildItem -Path $targetDir -File | Where-Object { 
    $_.Name -notin @($scriptName, "File contents.txt") -and 
    ($_.Extension.ToLower() -notin $imageExtensions)
}

# Display the directory and files that will be processed.
Write-Output "Processing files in directory: $targetDir"
Write-Output "Files found:"
$files | ForEach-Object { Write-Output " - $($_.Name)" }

# Wait for user confirmation to proceed.
Read-Host -Prompt "Press Enter to start processing the files"

foreach ($file in $files) {
    # Read the file content
    $content = Get-Content $file.FullName -Raw
    
    # Append the filename and its content to the output file.
    Add-Content -Path $outputFile -Value "$($file.Name):"
    Add-Content -Path $outputFile -Value "$content"
    Add-Content -Path $outputFile -Value "`n------------`n"
}

Write-Output "Processing complete. Output saved to 'File contents.txt'."
