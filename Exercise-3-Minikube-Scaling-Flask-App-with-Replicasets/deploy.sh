#!/usr/bin/env bash
set -e

echo "=== Exercise 3: Scaling Flask App on Single Node using ReplicaSets ==="

# Build image
docker build -t flashsale:1.0 .

# Load into Minikube
minikube image load flashsale:1.0

# Apply ReplicaSet and Service
kubectl apply -f flashsale-replicaset.yaml

# Wait for pods
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=Ready pods -l app=flashsale --timeout=90s

# Display initial status
echo "=== Initial ReplicaSet & Pods (3 Replicas) ==="
kubectl get rs
kubectl get pods -l app=flashsale -o wide

# Scale to 5 replicas
echo "=== Scaling ReplicaSet to 5 Replicas ==="
kubectl scale rs flashsale-rs --replicas=5
kubectl wait --for=condition=Ready pods -l app=flashsale --timeout=90s

echo "=== Scaled ReplicaSet & Pods (5 Replicas) ==="
kubectl get rs
kubectl get pods -l app=flashsale -o wide

# Test Self-Healing by deleting one pod
FIRST_POD=$(kubectl get pods -l app=flashsale -o jsonpath="{.items[0].metadata.name}")
echo "=== Testing Self-Healing: Deleting pod $FIRST_POD ==="
kubectl delete pod $FIRST_POD

echo "=== Pods After Self-Healing ==="
kubectl get pods -l app=flashsale -o wide

echo "=== Exercise 3 Completed Successfully ==="
