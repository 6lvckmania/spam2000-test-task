# spam2000 DevOps Test Task

GitOps setup with spam2000 app + VictoriaMetrics monitoring.

## Prerequisites

- Docker Desktop (running)
- minikube
- kubectl
- helm

## Quick Start

# Push to your repo
git add . && git commit -m "update repo url" && git push

# Install everything
chmod +x install.sh cleanup.sh
./install.sh
```

## Access

### ArgoCD
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
# URL: https://localhost:8080
# User: admin
# Pass: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Grafana
```bash
kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80
# URL: http://localhost:3000
# User: admin
# Pass: prom-operator
```

## Dashboards

Import these Grafana dashboards by ID:
- **1860** - Node Exporter Full
- **7249** - Kubernetes Cluster Monitoring
- **Custom** - spam2000 metrics available at `/metrics` endpoint

## Test GitOps

```bash
# Edit spam2000/app.yaml (change replicas)
# Commit and push
git add spam2000/app.yaml
git commit -m "scale app"
git push

# ArgoCD will auto-sync (~3 min)
```

## Cleanup

```bash
./cleanup.sh
```

## Structure

```
├── argocd-app.yaml       # ArgoCD Application
├── spam2000/             # App deployment
├── monitoring/           # VictoriaMetrics Helm chart
└── dashboards/           # Grafana dashboards
```
