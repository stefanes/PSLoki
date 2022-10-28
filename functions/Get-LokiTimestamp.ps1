function Get-LokiTimestamp {
    <#
    .Synopsis
        Create a timestamp suitable for Loki log entries (Unix Epoch in nanoseconds).
    .Description
        Calling this function will return a timestamp suitable for Loki:
            - If a timestamp is provided it will be parsed and converted.
            - If no timestamp is provided the current date/time will be used.
    .Example
        $timestamp = Get-LokiTimestamp
        Write-Host "Current Unix Epoch is: $timestamp"
    .Example
        $timestamp = Get-LokiTimestamp -Timestamp '2022-09-07T14:51:57Z'
        Write-Host "Unix Epoch for 2022-09-07T14:51:57Z is: $timestamp"
    .Example
        $timestamp = Get-LokiTimestamp -Timestamp '1662562317000000000'
        Write-Host "Unix Epoch for 1662562317000000000 is, you guessed it...: $timestamp"
    .Link
        https://en.wikipedia.org/wiki/Unix_time
    #>
    param (
        # Specifies the timstamp to parse, if provided.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Timestamp
    )

    process {
        Write-Debug -Message "Input timestamp: $Timestamp"

        # Check if already a Unix Epoch string
        if ($Timestamp -notmatch '^\d{10}(?:\d{9})?$') {
            if (-Not $Timestamp) {
                $date = [DateTime]::UtcNow
                Write-Debug -Message "Generated new timestamp: $($date.ToString('yyyy-MM-ddTHH:mm:ssZ'))"
            }
            else {
                $date = [DateTime]::Parse($Timestamp, [CultureInfo]::InvariantCulture)
            }

            # Convert to Unix Epoch
            $Timestamp = Get-Date $date.ToUniversalTime() -UFormat %s
            Write-Debug -Message "Converted to timestamp Unix Epoch: $Timestamp"
        }

        # Output Unix Epoch
        $Timestamp.PadRight(19, '0')
    }
}
