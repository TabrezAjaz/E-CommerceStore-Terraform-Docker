param(
    [string]$DockerHubUsername = 'tabrezajazdc',
    [string]$Tag = 'latest'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
$env:DOCKERHUB_USERNAME = $DockerHubUsername

docker info | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Docker engine is unavailable.' }
docker compose build
if ($LASTEXITCODE -ne 0) { throw 'Docker image build failed.' }

$images = 'user', 'product', 'cart', 'order', 'frontend'
foreach ($image in $images) {
    docker push "${DockerHubUsername}/ecommerce-${image}:${Tag}"
    if ($LASTEXITCODE -ne 0) { throw "Failed to push ecommerce-${image}:${Tag}." }
}
