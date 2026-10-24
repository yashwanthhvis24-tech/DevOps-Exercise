# PowerShell deployment script for Exercise 4: Docker Networking
Write-Host "=== Exercise 4: Docker Networking with Multiple Containers ===" -ForegroundColor Cyan

# 1. Create Bridge Network
Write-Host "`n[Step 1] Creating bridge network 'my-bridge-net'..." -ForegroundColor Yellow
docker network create --driver bridge my-bridge-net

# 2. Verify and Inspect Network
Write-Host "`n[Step 2] Verifying network list..." -ForegroundColor Yellow
docker network ls

Write-Host "`n[Step 3] Inspecting 'my-bridge-net'..." -ForegroundColor Yellow
docker network inspect my-bridge-net

# 3. Build Flask API Image
Write-Host "`n[Step 4] Building Flask API image..." -ForegroundColor Yellow
docker build -t flask-api .

# 4. Launch Containers
Write-Host "`n[Step 5] Launching containers on 'my-bridge-net'..." -ForegroundColor Yellow
docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker run -d --name redis --net=my-bridge-net redis:latest
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api

Start-Sleep -Seconds 3

Write-Host "`n=== Active Containers ===" -ForegroundColor Green
docker ps

# 5. Test Connectivity
Write-Host "`n[Step 6] Testing connectivity from Flask container to MySQL..." -ForegroundColor Yellow
docker exec flask ping -c 3 mysql

Write-Host "`n[Step 7] Testing connectivity from Flask container to Redis..." -ForegroundColor Yellow
docker exec flask ping -c 3 redis

Write-Host "`n[Step 8] Testing Flask REST API endpoint..." -ForegroundColor Yellow
curl.exe http://localhost:5001/about

Write-Host "`n=== Exercise 4 Completed Successfully ===" -ForegroundColor Cyan
