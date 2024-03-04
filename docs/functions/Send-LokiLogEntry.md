# Send-LokiLogEntry

## SYNOPSIS
Send Loki log entries to an HTTP endpoint.

## SYNTAX

```
Send-LokiLogEntry [-URI <Uri>] -Labels <Hashtable> -Entries <Hashtable[]> [-Timestamp <String>]
 [-AccessToken <String>] [<CommonParameters>]
```

## DESCRIPTION
Calling this function will return data returned from the request.

Notes:
    - Log entries must be provided in the format '@( @{...}, @{...} )'.
    - The log entries *must* include a 'line' property
    - For all other properties the parameter value is used if value it missing from input.

## EXAMPLES

### EXAMPLE 1
```
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
```

## PARAMETERS

### -URI
Specifies the URI for the request.
Override default using the LOKI_ENDPOINT or LOKI_HOST environment variables.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: URL

Required: False
Position: Named
Default value: $(
            if ($env:LOKI_ENDPOINT) {
                $env:LOKI_ENDPOINT
            } elseif ($env:LOKI_HOST) {
                "https://$env:LOKI_HOST/loki/api/v1/push" -replace '^https:\/\/http', 'http'
            } else {
                'https://logs-prod-us-central1.grafana.net/loki/api/v1/push'
            }
        )
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Labels
Specifies the stream labels.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Entries
Specifies the log entries to send.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases: LogEntries

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Timestamp
Specifies the timestamp of the log entries, converted to Unix Epoch if needed, unless provided in log entry.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccessToken
Specifies the access token to use for the communication.
Override default using the LOKI_ACCESS_TOKEN environment variable.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Token

Required: False
Position: Named
Default value: $(
            if ($script:LokiAccessTokenCache) {
                $script:LokiAccessTokenCache
            }
            elseif ($env:LOKI_ACCESS_TOKEN) {
                $env:LOKI_ACCESS_TOKEN
            }
        )
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-LokiTimestamp](Get-LokiTimestamp.md)

[https://grafana.com/docs/loki/latest/api/#push-log-entries-to-loki](https://grafana.com/docs/loki/latest/api/#push-log-entries-to-loki)

