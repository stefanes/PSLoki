﻿[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
param(
    [string] $ModuleName = 'PSLoki',
    [string] $ApiKey = $env:PSGALLERY_API_KEY
)

Write-Host "Publish module: $ModuleName" -ForegroundColor Blue

# Module details
$moduleDirectory = Join-Path -Path $PSScriptRoot -ChildPath '..'
$manifestPath = Join-Path -Path $moduleDirectory -ChildPath "$ModuleName.psd1"

# Import self
Import-Module -Name $manifestPath -Force -PassThru

# Publish PowerShell module
$excludes = @(
    '.git\**'
    '.github\**'
    '.vscode\**'
    'docs\**'
    'helpers\**'
    '.gitignore'
    'azure-pipelines.yml'
    '**\*.Tests.ps1'
    '*.md'
)
$splat = @{
    Name            = $manifestPath
    Repository      = 'PSGallery'
    Exclude         = $excludes
    NuGetApiKey     = $ApiKey
    AllowPrerelease = $true
    Force           = $true
}
Publish-Module @splat

# Exit script
Write-Host "Publish module done: $ModuleName" -ForegroundColor Blue
exit 0
