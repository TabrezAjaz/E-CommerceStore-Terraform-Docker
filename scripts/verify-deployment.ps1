param([Parameter(Mandatory)][string]$BaseUrl)
$ErrorActionPreference = 'Stop'
$base = $BaseUrl.TrimEnd('/')
$checks = @(
    @{ Name = 'Frontend'; Path = '/health'; Expected = 'Frontend is Live' },
    @{ Name = 'User'; Path = '/user/'; Expected = 'User Service Running' },
    @{ Name = 'Product'; Path = '/product/'; Expected = 'Product Service Running' },
    @{ Name = 'Cart'; Path = '/cart/'; Expected = 'Cart Service Running' },
    @{ Name = 'Order'; Path = '/order/'; Expected = 'Order Service Running' }
)
foreach ($check in $checks) {
    $response = (Invoke-RestMethod -Uri "$base$($check.Path)" -TimeoutSec 10).Trim()
    if ($response -ne $check.Expected) { throw "$($check.Name) verification failed." }
    Write-Host "PASS $($check.Name): $response"
}
