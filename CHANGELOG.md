# Changelog

## Version 0.1.5

- Override defaults using the `LOKI_ENDPOINT` **or** `LOKI_HOST` environment variables in [`Send-LokiLogEntry`](docs/functions/Send-LokiLogEntry.md).

## Version 0.1.4

- [`Get-LokiTimestamp`](docs/functions/Get-LokiTimestamp.md) now knows how to parse `DateTime` objects with the `-Date` parameter.

## Version 0.1.3

- Add support for modifying the timestamp returned by `Get-LokiTimestamp` by adding/subtracting seconds.

## Version 0.1.2

- Add support for Windows PowerShell (Note: PowerShell Core is recommended).

## Version 0.1.1

- :recycle: INTERNAL: Make timestamps culture-independent.

## Version 0.1.0

- Initial version, see [README.md](README.md#usage) for how to use this module.
- :new: Functions for publishing log entries to Loki:
  - [`Get-LokiTimestamp`](docs/functions/Get-LokiTimestamp.md)
  - [`Send-LokiLogEntry`](docs/functions/Send-LokiLogEntry.md)
