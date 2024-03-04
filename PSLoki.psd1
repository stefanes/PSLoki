@{
    Description   = 'PowerShell module for pushing log entries to Loki'
    ModuleVersion = '0.1.5'
    RootModule    = 'PSLoki.psm1'
    Author        = 'Stefan Eskelid'
    Copyright     = 'Copyright 2023 Stefan Eskelid. All rights reserved.'
    Guid          = '59642104-9261-458d-a5f0-b18f82437cb9'
    PrivateData   = @{
        PSData = @{
            # Prerelease   = 'beta1'
            Tags         = 'Loki', 'Grafana'
            ProjectURI   = 'https://github.com/stefanes/PSLoki'
            LicenseURI   = 'https://github.com/stefanes/PSLoki/blob/main/LICENSE'
            ReleaseNotes = "See https://github.com/stefanes/PSLoki/blob/main/CHANGELOG.md"
        }
    }
}
