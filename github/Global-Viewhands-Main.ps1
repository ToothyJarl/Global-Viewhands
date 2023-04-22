
# Functions

function Write-HostCenter {
    param([string]$Message)
    try {
        $consoleWidth = $Host.UI.RawUI.BufferSize.Width
        $padding = ' ' * (([Math]::Max(0, $consoleWidth / 2) - [Math]::Floor($Message.Length / 2)))
        return $padding + $Message
    }
    catch {
        # If the message is too long, just print it
        Write-Host $Message
    }
}

function Write-StringColor ([string]$Text, [System.ConsoleColor]$Color, [bool]$Center = $false, [bool]$NewLine = $true) {
    if ($Center) { $Text = Write-HostCenter $Text }
    $currentForegroundColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text -NoNewline:(!$NewLine)
    $Host.UI.RawUI.ForegroundColor = $currentForegroundColor
}

function Remove-Lines {
    param([int]$LinesToRemove)

    for ($i = 0; $i -lt $LinesToRemove; $i++) {
        # Move cursor up one line
        [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop - 1)

        # Overwrite the line with spaces
        Write-Host (" " * [System.Console]::BufferWidth)

        # Move cursor up to the start of the line
        [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop - 1)
    }
}

function WriteTutorial {
    Write-HostCenter ""
    Write-HostCenter "Global Viewhands has successfully installed!"
    Write-HostCenter "Launch H1-Mod, and go to Options > Viewhands."
    Write-HostCenter "The rest of the instructions are on the github page."
    Write-HostCenter ""
}

function Install-GlobalViewhands {
    param(
        [string]$directory
    )

    $zipUrl = "https://github.com/ToothyJarl/Global-Viewhands/releases/latest/download/Global-Viewhands.zip"
    $downloadPath = Join-Path $directory "Global-Viewhands.zip"

    Write-StringColor (Write-HostCenter "Downloading") "Red"
    Invoke-WebRequest -Uri $zipUrl -OutFile $downloadPath

    Write-StringColor (Write-HostCenter "Extracting") "Red"
    $extractionDirectory = Join-Path $directory "h1-mod"
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $zipArchive = [System.IO.Compression.ZipFile]::OpenRead($downloadPath)

    foreach ($entry in $zipArchive.Entries) {
        $destinationPath = Join-Path $extractionDirectory $entry.FullName

        $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)
        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
        }

        $entryStream = $entry.Open()
        $fileStream = [System.IO.File]::Create($destinationPath)
        $entryStream.CopyTo($fileStream)
        $fileStream.Close()
        $entryStream.Close()
    }

    $zipArchive.Dispose()

    
    Write-StringColor (Write-HostCenter "Removing temporary files") "Red"
    Remove-Item $downloadPath

    WriteTutorial
}


Add-Type -AssemblyName System.Windows.Forms

function BrowseForFolder {
    # Create a new FolderBrowserDialog
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog

    # Set the dialog properties
    $folderDialog.Description = "Select a folder"

    # Show the dialog and store the result
    $dialogResult = $folderDialog.ShowDialog()

    # If the user clicked OK, return the selected folder path
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderDialog.SelectedPath
    }

    # If the user clicked Cancel or closed the dialog, return $null
    return $null
}






Write-HostCenter ""
Write-StringColor (Write-HostCenter "Automatic Global Viewhands Installer") "Red"
Write-StringColor (Write-HostCenter "Modern Warfare Remastered") "Red"
Write-HostCenter ""
Write-StringColor (Write-HostCenter "Do you want to") "White"
Write-StringColor (Write-HostCenter "[ 1 ]: Manually Select MWR game folder") "White"
Write-StringColor (Write-HostCenter "[ 2 ]: Automatically find it          ") "White"
Write-HostCenter ""

# Ask question with color and centering
Write-StringColor (Write-HostCenter "Enter 1 or 2: ") "White"
$keyInfo = [System.Console]::ReadKey($true)
$choice = $keyInfo.KeyChar
Write-Host ""

Remove-Lines 6

if ($choice -eq "1") {
    $selectedFolderPath = BrowseForFolder

    if ($selectedFolderPath) {
        $directory = $selectedFolderPath
        $fileList = @("common.ff", "h1_sp64_ship.exe")
        $missingFiles = @()

        # Check if all files in $fileList are found in the selected folder
        foreach ($filename in $fileList) {
            $filePath = Join-Path $directory $filename
            if (-not (Test-Path $filePath)) {
                $missingFiles += $filename
            }
        }

        if ($missingFiles.Count -eq 0) {
            Write-HostCenter "Modern Warfare Remastered has been found at"
            Write-HostCenter $directory
            Write-HostCenter ""
            Start-Sleep -Seconds 3
            Write-StringColor (Write-HostCenter "Installing Global Viewhands") "Red"
            Install-GlobalViewhands -directory $directory
        } else {
            Write-HostCenter "No Modern Warfare Remastered directory was found."
            Write-HostCenter "Please make sure to pick the correct directory."
            Write-HostCenter ""
        }
    } else {
        Write-HostCenter "No folder selected."
    }

    
} elseif ($choice -eq "2") {
    # Automatic search
    Write-HostCenter "Searching for Modern Warfare Remastered, this may take some time."
    Write-HostCenter "You can minimize this window if you want, we will alert you when it is found!"
    Write-HostCenter ""

    $found = $false
    $fileList = @("common.ff")

    try {
        $drives = Get-PSDrive -PSProvider FileSystem
        foreach ($drive in $drives) {
            $searchPath = $drive.Root
            $exeFiles = Get-ChildItem -Path $searchPath -Recurse -Include h1_sp64_ship.exe -ErrorAction SilentlyContinue -Force -PipelineVariable currentItem | ForEach-Object {
                [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop - 1)
                Write-Host (" " * [System.Console]::BufferWidth)
                [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop - 1)
                Write-StringColor (Write-HostCenter "$($currentItem.FullName)") "Red"
                $_
            }

            if ($exeFiles) {
                foreach ($file in $exeFiles) {
                    $directory = Split-Path $file.FullName
                    $allFound = $true
                    foreach ($filename in $fileList) {
                        $filePath = Join-Path $directory $filename
                        if (-not (Test-Path $filePath)) {
                            $allFound = $false
                            break
                        }
                    }
                    if ($allFound) {
                        Remove-Lines 3
                        Write-HostCenter "Modern Warfare Remastered has been found at"
                        Write-HostCenter $directory
                        Write-HostCenter ""

                        Start-Sleep -Seconds 3

                        Write-StringColor (Write-HostCenter "Installing Global Viewhands") "Red"

                        Install-GlobalViewhands -directory $directory

                        
                        $found = $true
                        break
                    }
                }
            }

            if ($found) {
                break
            }
        }

        if (-not $found) {
            Write-HostCenter "No Modern Warfare Remastered directory was found."
            Write-HostCenter "Please make sure to have installed it or verify its integrity."
        }
    } catch {
        Write-HostCenter "An error occured, please restart the installer and try again!"
    }
} else {
    Write-HostCenter "Invalid choice. Please enter either 1 or 2."
}


# Pause
Pause
