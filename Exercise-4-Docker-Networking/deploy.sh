#!/usr/bin/env bash
set -e

echo "=== Exercise 4: Docker Networking with Multiple Containers ==="

# 1. Create Bridge Network
echo -e "\n[Step 1] Creating bridge network 'my-bridge-net'..."
docker network create --driver bridge my-bridge-net

# 2. Verify and Inspect Network
echo -e "\n[Step 2] Verifying network list..."
docker network ls

echo -e "\n[Step 3] Inspecting 'my-bridge-net'..."
docker network inspect my-bridge-net

# 3. Build Flask API Image
echo -e "\n[Step 4] Building Flask API image..."
docker build -t flask-api .

# 4. Launch Containers
echo -e "\n[Step 5] Launching containers on 'my-bridge-net'..."
docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker run -d --name redis --net=my-bridge-net redis:latest
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api

sleep 3

echo -e "\n=== Active Containers ==="
docker ps

# 5. Test Connectivity
echo -e "\n[Step 6] Testing connectivity from Flask container to MySQL..."
docker exec flask ping -c 3 mysql

echo -e "\n[Step 7] Testing connectivity from Flask container to Redis..."
docker exec flask ping -c 3 redis

echo -e "\n[Step 8] Testing Flask REST API endpoint..."
curl -s http://localhost:5001/about

echo -e "\n\n=== Exercise 4 Completed Successfully ==="
