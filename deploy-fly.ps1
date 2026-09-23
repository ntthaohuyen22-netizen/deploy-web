# Fly.io Deployment Script for MenuGoBE
# Chạy script này SAU KHI đã: fly auth login + fly launch --no-deploy

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Deploy MenuGoBE len Fly.io" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# === 1. Kiem tra Fly CLI da cai chua ===
Write-Host "[1/6] Kiem tra Fly CLI..." -ForegroundColor Yellow
fly version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Fly CLI chua cai. Cai dat:" -ForegroundColor Red
    Write-Host 'powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"' -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# === 2. Set biến môi trường từ appsettings.json ===
Write-Host "[2/6] Set biến môi trường..." -ForegroundColor Yellow

fly secrets set `
  ConnectionStrings__DefaultConnection="Host=aws-1-ap-southeast-1.pooler.supabase.com;Port=6543;Database=postgres;Username=postgres.fsjaqhsmfaodnbzryauj;Password=MenuGoCapstoneProject;SSL Mode=Prefer;Trust Server Certificate=true;Maximum Pool Size=20;Minimum Pool Size=2;Connection Idle Lifetime=60;Connection Pruning Interval=10;Timeout=15;Command Timeout=120;Keepalive=30;Tcp Keepalive=true;Tcp Keepalive Time=30;Tcp Keepalive Interval=10"

fly secrets set Jwt__Key="ThisIsAVerySecureAndLongSecretKeyForMenuGoProject"
fly secrets set Jwt__Issuer="MenuGoBackend"
fly secrets set Jwt__Audience="MenuGoFrontend"

fly secrets set CloudinarySettings__CloudName="kabvvhn3"
fly secrets set CloudinarySettings__ApiKey="398148388746386"
fly secrets set CloudinarySettings__ApiSecret="wufaZ3BAXGkGO4Hi2ZL9hcBzrKQ"

fly secrets set MailSettings__Mail="inspirevividproject.group@gmail.com"
fly secrets set MailSettings__DisplayName="MenuGo System"
fly secrets set MailSettings__Password="ibeugiiaysopyzcd"
fly secrets set MailSettings__Host="smtp.gmail.com"
fly secrets set MailSettings__Port="587"

fly secrets set PayOS__ClientId="037edfe2-772c-4b57-8c8b-08b1da1d37cc"
fly secrets set PayOS__ApiKey="c2ced022-f68b-4902-806e-a4bb09902b7d"
fly secrets set PayOS__ChecksumKey="dd0d1c0e59e8d7f7cc339f39f735adacf041d80597a8a83a7497489b42885850"

fly secrets set PointSystem__EarnRate_SpendAmount="100000"
fly secrets set PointSystem__EarnRate_PointReward="1000"
fly secrets set PointSystem__MinPointsToUse="50000"
fly secrets set PointSystem__MaxDiscountPercentage="50"

Write-Host ""
Write-Host "[3/6] Deploy..." -ForegroundColor Yellow
fly deploy

Write-Host ""
Write-Host "[4/6] Trang thai app..." -ForegroundColor Yellow
fly status

Write-Host ""
Write-Host "[5/6] Logs (5s)..." -ForegroundColor Yellow
timeout 5 fly logs
if ($LASTEXITCODE -eq 124) {
    Write-Host "(Da timeout 5s, OK)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[6/6] Test health..." -ForegroundColor Yellow
$appName = fly status --json | Select-String -Pattern '"Name":"([^"]+)"' | ForEach-Object { $_.Matches[0].Groups[1].Value }
Write-Host "App URL: https://$appName.fly.dev" -ForegroundColor Green
curl.exe "https://$appName.fly.dev/health" --max-time 15

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  HOAN THANH!" -ForegroundColor Green
Write-Host "  URL: https://$appName.fly.dev" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
