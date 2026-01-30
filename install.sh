#!/bin/bash
set -e

echo "==> Checking prerequisites..."

# Check Docker
if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker not running. Start Docker Desktop and retry."
  exit 1
fi

# Check tools
for tool in minikube kubectl helm; do
  if ! command -v $tool >/dev/null 2>&1; then
    echo "ERROR: $tool not found. Install it first."
    exit 1
  fi
done

echo "==> Starting Minikube..."
PROFILE=${MINIKUBE_PROFILE:-spam2000-test-task}
minikube start -p "$PROFILE" --cpus=2 --memory=4096
kubectl config use-context "$PROFILE"

echo "==> Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait deployment argocd-server -n argocd --for condition=Available=True --timeout=300s

echo "==> Creating ArgoCD Application..."
kubectl apply -f argocd-app.yaml

echo ""
echo "==> Done!"
echo ""
echo "ArgoCD:"
echo "  kubectl -n argocd port-forward svc/argocd-server 8080:443"
echo "  Password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
echo ""
echo "Grafana:"
echo "  kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80"
echo "  Login: admin / prom-operator"
echo ""
