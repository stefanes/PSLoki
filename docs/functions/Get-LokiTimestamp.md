# Get-LokiTimestamp

## SYNOPSIS
Create a timestamp suitable for Loki log entries (Unix Epoch in nanoseconds).

## SYNTAX

```
Get-LokiTimestamp [[-Timestamp] <String>] [[-AddSeconds] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Calling this function will return a timestamp suitable for Loki:
    - If a timestamp is provided it will be parsed and converted.
    - If no timestamp is provided the current date/time will be used.

## EXAMPLES

### EXAMPLE 1
```
$timestamp = Get-LokiTimestamp
Write-Host "Current Unix Epoch is: $timestamp"
```

### EXAMPLE 2
```
$timestamp = Get-LokiTimestamp -Timestamp '2022-09-07T14:51:57Z'
Write-Host "Unix Epoch for 2022-09-07T14:51:57Z is: $timestamp"
```

### EXAMPLE 3
```
$timestamp = Get-LokiTimestamp -Timestamp '1662562317000000000'
Write-Host "Unix Epoch for 1662562317000000000 is, you guessed it...: $timestamp"
```

## PARAMETERS

### -Timestamp
Specifies the timstamp to parse, if provided.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AddSeconds
Specifies the number of seconds to add to the timestamp.
The value can be negative or positive.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://en.wikipedia.org/wiki/Unix_time](https://en.wikipedia.org/wiki/Unix_time)

