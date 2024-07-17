# Create PowerShell Module GitHub Action

This action creates a PowerShell module from source files.

## Inputs

### `ModuleName`

**Required** The name of the PowerShell module.

### `Source`

**Optional** The source directory containing the module (relative to the workspace).

### `Output`

**Optional** TThe output directory for storing the module (relative to the workspace).

### `Imports`

**Required** Comma-separated list of import folders.

### `Debug`

**Optional** Enable debug mode. The default is `false``.

## Example usage

```yaml
name: Build PowerShell Module

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: windows-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          path: MySuperModule  # Custom path for the checkout

      - name: Create PowerShell Manifest
        uses: your-username/your-repo@v1  # Replace with your repository details for the createpowershellmanifest action
        with:
          ModuleName: 'your-module'
          Source: 'MySuperModule'  # Use the custom path here
          Debug: 'true'

      - name: Create PowerShell Module
        uses: your-username/your-repo@v1  # Replace with your repository details for the createpowershellmodule action
        with:
          ModuleName: 'your-module'
          Source: 'MySuperModule'  # Use the custom path here
          Imports: 'folder1,folder2'
          Debug: 'true'

      - name: Upload PowerShell Module
        uses: actions/upload-artifact@v2
        with:
          name: your-module-output
          path: ${{ github.workspace }}/output
