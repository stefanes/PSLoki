[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

BeforeAll {
    $LokiURI = 'https://logs-prod-us-central1.grafana.net/loki/api/v1/push'
}

Describe "Get-LokiTimestamp" {
    It "Can get new Loki timestamp (Unix Epoch)" {
        Get-LokiTimestamp | Should -Not -Be $null
    }

    It "Can get Unix Epoch from date" {
        Get-LokiTimestamp -Timestamp '2022-09-07T14:51:57Z' | Should -Be '1662562317000000000'
    }

    It "Can get Unix Epoch back" {
        Get-LokiTimestamp -Timestamp '1662562317000000000' | Should -Be '1662562317000000000'
    }
}

Describe "Send-LokiLogEntry" {
    It "Can send single Loki log entry" {
        if ($env:LOKI_ACCESS_TOKEN) {
            $response = Send-LokiLogEntry -Labels @{
                'label' = 'value'
            } -Entries @(
                @{
                    line = "log something"
                }
            )
        }
        else {
            Write-Warning "Environment variable '`$env:LOKI_ACCESS_TOKEN' not set..."
        }
        $response | Should -Not -Be $null
    }

    It "Can send multiple Loki log entries metrics" {
        if ($env:LOKI_ACCESS_TOKEN) {
            $response = Send-LokiLogEntry -Labels @{
                'label' = 'value'
                'foo'   = 'bar'
            } -Entries @(
                @{
                    line = "log something"
                }
                @{
                    line = "log something else"
                }
            )
        }
        else {
            Write-Warning "Environment variable '`$env:LOKI_ACCESS_TOKEN' not set..."
        }
        $response | Should -Not -Be $null
    }

    It "Fails with invalid log entriy" {
        { Send-LokiLogEntry -Labels @{
            'label' = 'value'
        } -Entries @"
{
  "streams": [
    {
      "values": [["1666647194000000000" "log something"]],
      "stream": {
        "label": "value"
      }
    }
  ]
}
"@
        } | Should -Throw
    }

    It "Fails when invalid URI" {
        { Send-LokiLogEntry -URI $($LokiURI -replace '.net', '.com') -Labels @{} -Entries '' } | Should -Throw
    }
}
