[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$SkipNetwork
)

$ErrorActionPreference = 'Stop'
$previousPythonUtf8 = $env:PYTHONUTF8
$env:PYTHONUTF8 = '1'

function Invoke-NlmCommand {
    param([string[]]$Arguments)

    $output = & nlm @Arguments 2>&1 | Out-String
    [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Output = $output.Trim()
    }
}

function Test-NotebookLmMcpConfig {
    $candidates = @(
        (Join-Path (Get-Location) '.agents\mcp_config.json'),
        (Join-Path $env:USERPROFILE '.gemini\config\mcp_config.json'),
        (Join-Path $env:USERPROFILE '.gemini\antigravity\mcp_config.json')
    ) | Select-Object -Unique

    foreach ($path in $candidates) {
        if (-not (Test-Path -LiteralPath $path)) { continue }
        try {
            $config = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
            foreach ($server in $config.mcpServers.PSObject.Properties) {
                $command = [string]$server.Value.command
                if ([IO.Path]::GetFileName($command) -match '^notebooklm-mcp(?:\.exe)?$') {
                    return $true
                }
            }
        }
        catch {
            continue
        }
    }
    return $false
}

try {
    $nlmCommand = Get-Command nlm -ErrorAction SilentlyContinue
    $mcpCommand = Get-Command notebooklm-mcp -ErrorAction SilentlyContinue
    $chromeCandidates = @(
        (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
        (Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe')
    )
    $chromeInstalled = [bool]($chromeCandidates | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1)

    if (-not $nlmCommand) {
        $result = [ordered]@{
            status = 'cli_missing'
            cliInstalled = $false
            mcpBinaryInstalled = [bool]$mcpCommand
            chromeInstalled = $chromeInstalled
            authValid = $false
            mcpConfigured = Test-NotebookLmMcpConfig
            websiteReachable = $null
            nextAction = 'Ask for permission before installing notebooklm-mcp-cli.'
        }
        if ($Json) { $result | ConvertTo-Json -Depth 4 } else { $result }
        exit 20
    }

    $version = Invoke-NlmCommand -Arguments @('--version')
    $auth = Invoke-NlmCommand -Arguments @('login', '--check')
    $doctor = Invoke-NlmCommand -Arguments @('doctor')
    $websiteReachable = $null
    if (-not $SkipNetwork) {
        try {
            $response = Invoke-WebRequest -Uri 'https://notebooklm.google.com' -Method Head -UseBasicParsing -TimeoutSec 15
            $websiteReachable = $response.StatusCode -ge 200 -and $response.StatusCode -lt 400
        }
        catch {
            $websiteReachable = $false
        }
    }

    $authValid = $auth.ExitCode -eq 0 -and $auth.Output -match '(?i)authenticated|authentication valid|success'
    $hasSavedSession = $doctor.Output -match '(?i)Cookies:\s*present' -and $doctor.Output -match '(?i)CSRF token:\s*yes'
    $mcpConfigured = Test-NotebookLmMcpConfig

    if ($authValid -and $mcpConfigured) {
        $status = 'ready'
        $nextAction = 'Reload AntiGravity MCP and perform one read-only notebook list check.'
        $exitCode = 0
    }
    elseif (-not $authValid -and $hasSavedSession) {
        $status = 'stale_session_or_internal_api_error'
        $nextAction = 'Run one visible PowerShell login, then verify once. Stop if it still fails.'
        $exitCode = 10
    }
    elseif (-not $authValid) {
        $status = 'authentication_required'
        $nextAction = 'Run nlm login in a visible PowerShell window, then verify once.'
        $exitCode = 10
    }
    else {
        $status = 'mcp_setup_required'
        $nextAction = 'Ask for permission, then run nlm setup add antigravity once.'
        $exitCode = 30
    }

    $result = [ordered]@{
        status = $status
        cliInstalled = $true
        cliVersion = ($version.Output -replace '(?i)^nlm version\s*', '').Trim()
        mcpBinaryInstalled = [bool]$mcpCommand
        chromeInstalled = $chromeInstalled
        authValid = $authValid
        savedSessionPresent = $hasSavedSession
        mcpConfigured = $mcpConfigured
        websiteReachable = $websiteReachable
        nextAction = $nextAction
    }

    if ($Json) { $result | ConvertTo-Json -Depth 4 } else { $result }
    exit $exitCode
}
finally {
    if ($null -eq $previousPythonUtf8) {
        Remove-Item Env:PYTHONUTF8 -ErrorAction SilentlyContinue
    }
    else {
        $env:PYTHONUTF8 = $previousPythonUtf8
    }
}
