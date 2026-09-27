$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

docker info | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Docker engine is unavailable.' }
docker compose build
if ($LASTEXITCODE -ne 0) { throw 'Docker image build failed.' }
docker compose up -d --wait --wait-timeout 300
if ($LASTEXITCODE -ne 0) { throw 'Docker Compose stack did not become healthy.' }

try {
    $checks = @(
        @{ Name = 'Frontend'; Url = 'http://localhost:8080/health'; Expected = 'Frontend is Live' },
        @{ Name = 'User'; Url = 'http://localhost:8080/user/'; Expected = 'User Service Running' },
        @{ Name = 'Product'; Url = 'http://localhost:8080/product/'; Expected = 'Product Service Running' },
        @{ Name = 'Cart'; Url = 'http://localhost:8080/cart/'; Expected = 'Cart Service Running' },
        @{ Name = 'Order'; Url = 'http://localhost:8080/order/'; Expected = 'Order Service Running' }
    )

    foreach ($check in $checks) {
        $response = (Invoke-RestMethod -Uri $check.Url -TimeoutSec 10).Trim()
        if ($response -ne $check.Expected) { throw "$($check.Name) returned unexpected response: $response" }
        Write-Host "PASS $($check.Name): $response"
    }

    docker compose ps
} finally {
    docker compose down -v
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Docker Compose cleanup returned a nonzero exit code.' }
}
