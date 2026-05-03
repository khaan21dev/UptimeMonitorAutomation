param($Timer)

Write-Host "Uptime check started at $(Get-Date)"

# Target URL to monitor
$url = "https://elkhan-cloud.com"

# Logic App URL from environment variable
$logicAppUrl = $env:LOGIC_APP_URL

# Initialize variables
$status = "up"
$statusCode = 0
$responseTime = 0

# Check website
try {
    $startTime = Get-Date
    $response = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing -TimeoutSec 10
    $responseTime = ((Get-Date) - $startTime).TotalMilliseconds
    $statusCode = $response.StatusCode

    if ($statusCode -eq 200) {
        $status = "up"
        Write-Host "SUCCESS: Site is UP. Status: $statusCode, Response time: $responseTime ms"
    } else {
        $status = "down"
        Write-Host "WARNING: Site returned status $statusCode"
    }
}
catch {
    $status = "down"
    Write-Host "FAILURE: Site is DOWN. Error: $($_.Exception.Message)"
}

# Log result to Log Analytics
$logEntry = @{
    TimeGenerated = (Get-Date).ToUniversalTime().ToString("o")
    URL           = $url
    Status        = $status
    StatusCode    = $statusCode
    ResponseTimeMs = $responseTime
} | ConvertTo-Json

Write-Host "Log entry: $logEntry"

# Trigger Logic App if site is down
if ($status -eq "down") {
    Write-Host "Site is DOWN - triggering Logic App alert"

    $body = @{
        status    = "down"
        url       = $url
        statusCode = $statusCode
        timestamp = (Get-Date).ToString()
    } | ConvertTo-Json

    try {
        Invoke-RestMethod -Uri $logicAppUrl -Method Post -Body $body -ContentType "application/json"
        Write-Host "Logic App triggered successfully"
    }
    catch {
        Write-Host "Failed to trigger Logic App: $($_.Exception.Message)"
    }
} else {
    Write-Host "Site is UP - no alert needed"
}

Write-Host "Uptime check completed at $(Get-Date)"
