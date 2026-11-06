# ============================================================================
# Script .....: install.ps1
# Application : Portable installation of uv environment on Windows x64
# Author .....: Walter Dal'Maz Silva
#
# Usage
# =====
#
# - Adding packages
#     ./uv --system-certs add <package>
#
# - Syncing the environment
#     ./uv sync --system-certs
#
# ============================================================================

$env:UV_CACHE_DIR = "$PSScriptRoot/cache"

@"
[project]
name = "pythonuv"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.13"
dependencies = [
    "jupyterlab>=4.6.5",
    "matplotlib>=3.11.2",
    "numpy>=2.5.4",
    "pandas>=3.1.1",
    "scikit-image>=0.26.0",
    "scikit-learn>=1.9.1",
    "scipy>=1.18.1",
]

[dependency-groups]
dev = [
    "thonny>=5.0.1",
]
"@ `
    | Out-File -FilePath "$PSScriptRoot/pyproject.toml" -Encoding utf8

"3.13" `
    | Out-File -FilePath "$PSScriptRoot/.python-version" -Encoding utf8

"./uv/uv run jupyter lab" `
    | Out-File -FilePath "$PSScriptRoot/jupyter.ps1" -Encoding utf8

function Install-Uv {
    Write-Host "Portable uv in Windows x64" -Foreground Cyan

    # Path to the version to download:
    $releases="https://releases.astral.sh/github/uv/releases/download"
    $uvZipFile="uv-x86_64-pc-windows-msvc.zip"
    $uvUrlFile="$releases/0.13.7/$uvZipFile"

    $uvTarget="$PSScriptRoot/uv"

    if (!(Test-Path $uvTarget)) {
        Write-Host "Application not found, installing..." -Foreground Green

        # Download if needed:
        if (!(Test-Path $uvZipFile)) {
            Start-BitsTransfer `
                -Source $uvUrlFile `
                -Destination $uvZipFile `
                -ErrorAction Stop
        }

        # Test and extract:
        if (!(Test-Path $uvZipFile)) {
            Write-Host "Download failed, try again..." -Foreground Red
        } else {
            Expand-Archive -Path $uvZipFile -DestinationPath $uvTarget
        }

        # Test and delete:
        if (!(Test-Path "$uvTarget/uv.exe")) {
            Write-Host "Expansion of ZIP failed, try again..." -Foreground Red
        } else {
            Remove-Item -Force $uvZipFile
        }
    }
}

Install-Uv

& "./uv/uv sync --system-certs"
