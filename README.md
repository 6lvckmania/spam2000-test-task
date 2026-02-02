# spam2000-test-task

GitOps setup for deploying `spam2000` application with VictoriaMetrics monitoring on Minikube using Argo CD.

## Components

- **Minikube** - local Kubernetes cluster
- **Argo CD** - GitOps continuous delivery
- **VictoriaMetrics** - metrics collection and storage
- **Grafana** - dashboards and visualization
- **spam2000** - test application generating metrics

## Prerequisites

- Docker Desktop (running)
- `minikube`, `kubectl`, `helm`

## Quick Start

```bash
# Clone and configure
git clone https://github.com/YOUR_GITHUB_USERNAME/spam2000-test-task.git
cd spam2000-test-task

# Update YOUR_GITHUB_USERNAME in argocd-app.yaml, commit and push

# Deploy everything
chmod +x install.sh cleanup.sh
./install.sh
```

## Access

**Argo CD:**
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
# https://localhost:8080
# User: admin
# Pass: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Grafana:**
```bash
kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80
# http://localhost:3000
# User: admin
# Pass: kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d
```

## Dashboards

VictoriaMetrics automatically provisions dashboards for monitoring:

**Kubernetes Cluster:**
- **Kubernetes / Views / Global** - cluster overview
- **Kubernetes / Views / Nodes** - CPU, Memory, Network of nodes
- **Kubernetes / Views / Pods** - pod status and resources
- **Node Exporter Full** - detailed server monitoring (CPU, RAM, Disk, Network)

**Kubernetes Components:**
- **Kubernetes / System / API Server** - API server monitoring
- **Kubernetes / System / CoreDNS** - DNS monitoring
- **Kubernetes / Kubelet** - kubelet monitoring

**Monitoring Stack:**
- **VictoriaMetrics - single-node** - metrics storage
- **VictoriaMetrics - vmagent** - metrics collection
- **Grafana Overview** - Grafana monitoring

**spam2000 Metrics:**
- **spam2000 Metrics** - auto-created dashboard with application metrics

View metrics via Explore: Grafana → Explore → VictoriaMetrics datasource → `{job="spam2000"}`

## GitOps Workflow

```bash
# Edit spam2000/app.yaml (e.g., change replicas)
git add spam2000/app.yaml
git commit -m "scale app"
git push

# Argo CD auto-syncs within ~3 minutes
```

## Cleanup

```bash
./cleanup.sh
```
