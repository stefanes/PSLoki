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
    .Example
        $timestamp = Get-LokiTimestamp -Date $([DateTime]::Parse('2022-09-07T14:51:57Z'))
        Write-Host "Unix Epoch for 2022-09-07T14:51:57Z is: $timestamp"
    .Link
        https://en.wikipedia.org/wiki/Unix_time
    #>
    param (
        # Specifies the timstamp to parse, if provided.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Timestamp,

        # Specifies the date to parse, if provided.
        [Parameter(ValueFromPipelineByPropertyName)]
        [DateTime] $Date,

        # Specifies the number of seconds to add to the timestamp. The value can be negative or positive.
        [int] $AddSeconds = 0
    )

    begin {
        $dateFormat = 'yyyy-MM-ddTHH:mm:ssZ'
    }

    process {
        # Timestamp parameter provided
        if ($Timestamp) {
            # Check if already a Unix Epoch string
            if ($Timestamp -notmatch '^\d{10}(?:\d{9})?$') {
                $timestampAsDate = [DateTime]::Parse($Timestamp, [CultureInfo]::InvariantCulture).ToUniversalTime()
                Write-Debug -Message "Provided timestamp is a string: $($timestampAsDate.ToString($dateFormat))"
            } else {
                $timestampAsDate = [DateTime]::Parse('1970-01-01T00:00:00Z', [CultureInfo]::InvariantCulture).ToUniversalTime().AddSeconds($Timestamp.Substring(0, 10))
                Write-Debug -Message "Provided timestamp is a number: $($timestampAsDate.ToString($dateFormat))"
            }
        } elseif ($Date) {
            $timestampAsDate = $Date.ToUniversalTime()
            Write-Debug -Message "Provided timestamp is a date: $($Date.ToString($dateFormat))"
        } else {
            # No timestamp or date provided, generating a brand new timestamp
            $timestampAsDate = [DateTime]::UtcNow
            Write-Debug -Message "Generated new timestamp: $($timestampAsDate.ToString($dateFormat))"
        }

        # Convert to Unix Epoch
        $out = Get-Date ($timestampAsDate.AddSeconds($AddSeconds)) -UFormat %s
        Write-Debug -Message "Converted to timestamp Unix Epoch: $out"

        # Output Unix Epoch
        $out.PadRight(19, '0')
    }
}
