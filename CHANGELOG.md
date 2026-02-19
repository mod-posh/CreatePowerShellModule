# Changelog

All changes to this project should be reflected in this document.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [[0.0.2.0]](https://github.com/mod-posh/CreatePowerShellModule/releases/tag/v0.0.2.0) - 2026-02-19

### BUGFIXES

**issue-1** Recursing importFolder returned no files
> Added Where-Object to filter out any potential Pester Test files

**issue-2** Set-Content not creating file
> Force the file creation using New-Item
> Add utf8 encoding on file write

## [[0.0.1.0]](https://github.com/mod-posh/CreatePowerShellModule/releases/tag/v0.0.1.0) - 2024-07-17

### Summary of the Create PowerShell Module Script

This Github Action automates the creation of a PowerShell module by aggregating function scripts from specified directories into a single module file (`.psm1`). It includes setup for variables, handles import folders, processes the function scripts, and creates the final module file. Debug logging and error handling are also included to provide detailed output and manage any issues during execution.

Features:

- Iterates over specified import directories.
- Collects and reads function scripts (`.ps1` files), excluding test scripts.
- Aggregates the contents of the function scripts into a single module file using a `StringBuilder`.
- Writes the aggregated contents from the `StringBuilder` to the `.psm1` module file.

This action is useful for automating the creation of a PowerShell module by collecting and consolidating function scripts from multiple directories into a single module file.
