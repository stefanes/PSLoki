function Send-LokiLogEntry {
    <#
    .Synopsis
        Send Loki log entries to an HTTP endpoint.
    .Description
        Calling this function will return data returned from the request.

        Notes:
            - Log entries must be provided in the format '@( @{...}, @{...} )'.
            - The log entries *must* include a 'line' property
            - For all other properties the parameter value is used if value it missing from input.
    .Example
        $response = Send-LokiLogEntry -Labels @{
            'label' = 'value'
            'foo'   = 'bar'
        } -Entries @(
            @{
                time = "1666644815000000000"
                line = "log something"
            }
            @{
                time = "1666644823000000000"
                line = "log something else"
            }
        )
        Write-Host "Log entries sent to Loki [$($response.StatusCode) $($response.StatusDescription)]"
    .Link
        Get-LokiTimestamp
    .Link
        https://grafana.com/docs/loki/latest/api/#push-log-entries-to-loki
    #>
    [CmdletBinding(DefaultParameterSetName = 'URI')]
    param (
        # Specifies the URI for the request.
        # Override default using the LOKI_ENDPOINT or LOKI_HOST environment variables.
        [Parameter(ParameterSetName = 'URI', ValueFromPipelineByPropertyName)]
        [Alias('URL')]
        [Uri] $URI = $(
            if ($env:LOKI_ENDPOINT) {
                $env:LOKI_ENDPOINT
            } elseif ($env:LOKI_HOST) {
                "https://$env:LOKI_HOST/loki/api/v1/push" -replace '^https:\/\/http', 'http'
            } else {
                'https://logs-prod-us-central1.grafana.net/loki/api/v1/push'
            }
        ),

        # Specifies the stream labels.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [hashtable] $Labels,

        # Specifies the log entries to send.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [Alias('LogEntries')]
        [hashtable[]] $Entries,

        # Specifies the timestamp of the log entries, converted to Unix Epoch if needed, unless provided in log entry.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Timestamp,

        # Specifies the access token to use for the communication.
        # Override default using the LOKI_ACCESS_TOKEN environment variable.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Token')]
        [string] $AccessToken = $(
            if ($script:LokiAccessTokenCache) {
                $script:LokiAccessTokenCache
            }
            elseif ($env:LOKI_ACCESS_TOKEN) {
                $env:LOKI_ACCESS_TOKEN
            }
        ),

        # Switch to output result to the console.
        [switch] $OutputToConsole,

        # Switch to still return the reponse even when the '-OutputToConsole' parameter is provided.
        [switch] $PassThru
    )

    begin {
        # Cache the access token (if provided)
        if ($AccessToken) {
            $script:LokiAccessTokenCache = $AccessToken
        }

        # Setup request headers
        $headers = @{
            'Content-Type'  = 'application/json'
            'Authorization' = "Bearer $AccessToken"
        }
    }

    process {
        # Construct Loki log entries to send
        $logEntries = @()
        foreach ($entry in $Entries) {
            $logEntryTime = if ($entry.time -gt 0) { $entry.time } else { Get-LokiTimestamp -Timestamp $Timestamp }
            $logEntries += @(, @(
                    $logEntryTime
                    $entry.line
                ))
        }

        # Setup parameters
        $splat = @{
            Method        = 'POST'
            Body          = @{
                streams = @(
                    @{
                        stream = $Labels
                        values = $logEntries
                    }
                )
            } | ConvertTo-Json -Depth 10
            Headers       = $headers
            TimeoutSec    = 60
            ErrorVariable = 'err'
        }
        if ($PSVersionTable.PSVersion.Major -le 5) {
            # Additional parameters *not* supported from PowerShell version 6
            $splat += @{
                UseBasicParsing = $true
            }
        }
        $err = @( )

        # Make the request
        # Note: Using 'Invoke-WebRequest' to get the headers
        $eap = $ErrorActionPreference
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Verbose -Message "Invoking web request: POST $URI"
        Write-Debug -Message "Loki log entries: $($splat.Body)"
        $response = Invoke-WebRequest @splat -Uri $URI
        $ErrorActionPreference = $eap

        # Check for error
        if ($err) {
            $errorMessage = @"
Failed to invoke request to:
    POST $URI

Error message:
    $($err.Message)

Exception:
    $($err.InnerException.Message)
"@
            Write-Error -Message $errorMessage -Exception $err.InnerException -Category ConnectionError
            return
        }

        # Output to console
        if ($OutputToConsole.IsPresent) {
            $columns = @(
                @{ label = 'Status'; expression = { "$($_.StatusCode) $($_.StatusDescription)" } }
            )
            $response | Select-Object $columns | ForEach-Object { $_ | Out-Host }
        }

        # Output response
        if (-Not $OutputToConsole.IsPresent -Or $PassThru.IsPresent) {
            $response
        }
    }
}
