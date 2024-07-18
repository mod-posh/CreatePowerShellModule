param (
    [string]$ModuleName,
    [string]$Source = "",
    [string]$Output = "",
    [string]$Imports,
    [string]$Debug = 'false'
)

try {
    Write-Host "::group::Starting the Create PowerShell Module task..."
    Write-Host "::group::Setting up variables"

    $Debug = [System.Convert]::ToBoolean($Debug)

    $sourcePath = if ([string]::IsNullOrEmpty($Source)) { $env:GITHUB_WORKSPACE } else { Join-Path $env:GITHUB_WORKSPACE $Source }
    $outputPath = if ([string]::IsNullOrEmpty($Output)) { Join-Path $env:GITHUB_WORKSPACE "output" } else { Join-Path $env:GITHUB_WORKSPACE $Output }

    $Module = Get-ChildItem -Path $sourcePath -Filter "$ModuleName.psd1" -Recurse
    $ModuleRoot = $Module.Directory.FullName
    $Destination = Join-Path $outputPath $ModuleName
    $modulePath = Join-Path $Destination "$ModuleName.psm1"

    if ($Debug) {
        Write-Host "ModuleName   : $ModuleName"
        Write-Host "SourcePath   : $sourcePath"
        Write-Host "OutputPath   : $outputPath"
        Write-Host "Destination  : $Destination"
        Write-Host "ModuleRoot   : $ModuleRoot"
        Write-Host "Imports      : $Imports"
    }

    $stringbuilder = [System.Text.StringBuilder]::new()
    $importFolders = $Imports.Split(',')

    Write-Host "::endgroup::"

    Write-Host "::group::Copying Manifest"

    if ($Debug) {
        Write-Host "Testing Output"
    }

    if (-not (Test-Path -Path $outputPath)) {
        New-Item -ItemType Directory -Path $outputPath | Out-Null
    }

    Write-Host "::group::Processing import folders..."
    foreach ($importFolder in $importFolders) {
        Write-Host "Importing from [$ModuleRoot\$importFolder]"
        if ($Debug) {
            Write-Host "Testing ImportFolder"
        }
        if (Test-Path -Path (Join-Path $ModuleRoot $importFolder)) {
            $fileList = Get-ChildItem -Path (Join-Path $ModuleRoot $importFolder) -Filter "*.ps1" -Exclude "*.Tests.ps1"
            foreach ($file in $fileList) {
                Write-Host "  Importing [.$($file.BaseName)]"
                if ($Debug) {
                    Write-Host "Reading file: $file.FullName"
                }
                $stringbuilder.AppendLine("# .$($file.BaseName)") | Out-Null
                $stringbuilder.AppendLine([System.IO.File]::ReadAllText($file.FullName)) | Out-Null
            }
        } else {
            Write-Host "##[warning]Folder $importFolder not found at $ModuleRoot"
        }
    }
    Write-Host "::endgroup::"

    Write-Host "::group::Creating module [$modulePath]"
    Set-Content -Path $modulePath -Value $stringbuilder.ToString()
    Write-Host "BuildModule task completed successfully."
    Write-Host "::endgroup::"
    Write-Host "::endgroup::"
}
catch {
    Write-Host "##[error]An error occurred: $($_.Exception.Message)"
    exit 1
}
