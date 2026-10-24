#!/usr/bin/env bash
set -e

echo "=== Exercise 2: Deploying Flask App on Minikube ==="

# Build image directly with minikube or docker
if command -v minikube &> /dev/null; then
  echo "Building and loading image into minikube..."
  docker build -t flask-app:latest .
  minikube image load flask-app:latest
fi

# Apply Deployment and Service
kubectl apply -f flask-deployment.yaml

# Wait for deployment rollout
kubectl rollout status deployment/flask-app --timeout=90s

# Display Status
echo "=== Deployments ==="
kubectl get deployments -o wide

echo "=== Pods ==="
kubectl get pods -l app=flask-app -o wide

echo "=== Services ==="
kubectl get services -o wide

echo "=== Exercise 2 Completed Successfully ==="
