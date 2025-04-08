# Infrastructure Setup for AWS EKS Cluster (Terraform + Terragrunt)

This repository contains the infrastructure code to provision an Amazon EKS cluster from scratch in a bare AWS account, following best practices using Terraform and Terragrunt.

## Directory Structure
```bash
├── infra/
│   ├── apps/                       # ArgoCD Applications (App of apps)
│   │   ├── root-app/
│   │   ├── sample-microservice/
│   │   ├── aws-load-balancer-controller/
│   │   ├── external-dns/
│   │   ├── cert-manager/
│   │   └── metrics-server/
│   ├── live/prod/                  # Terragrunt live environment
│   │   ├── vpc/
│   │   ├── eks/
│   │   ├── irsa/
│   │   │   ├── aws-load-balancer-controller/
│   │   │   └── external-dns/
│   │   └── argocd/
│   └── modules/                    # Terraform modules
│       ├── vpc/
│       ├── eks/
│       ├── irsa/
│       │   └── policies/
│       └── argocd/
├── sample-microservice/            # Python app + Dockerfile
│   ├── app/
│   │  └── main.py
│   ├── Dockerfile
│   └── requirements.txt           # Python app dependencies
├── root.hcl                       # Shared Terragrunt config
└── README.md                      # This file
```

## Getting Started

### 1. Bootstrap Remote State

```bash
cd infra/bootstrap
terraform init
terraform apply
terraform output -raw bucket_name > ../bucket_name.txt
```

### 2. Deploy VPC

```bash
cd infra/live/prod/vpc
terragrunt init
terragrunt apply
```

### 3. Deploy EKS Cluster

```bash
cd infra/live/prod/eks
terragrunt init
terragrunt apply
```

### 4. Deploy IRSA Roles

```bash
cd infra/live/prod/aws-load-balancer-controller
terragrunt init
terragrunt apply
cd ../external-dns
terragrunt init
terragrunt apply
```

### 5. Configure kubectl access
```bash
aws eks update-kubeconfig --region us-east-1 --name eks-cluster
kubectl get nodes
```

### 6. Deploy ArgoCD

```bash
cd infra/live/prod/argocd
terragrunt init
terragrunt apply
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Release Pipeline (GitHub Actions + GitOps)
``` 
[ GitHub Actions ]
     |
     |-- Build + Push Docker image
     |-- Update image.tag in values.yaml
     |-- Commit + Push to GitOps repo (this repo)
     ↓
[ ArgoCD ]
     |
     |-- Detects change in Git
     |-- Syncs Helm chart with updated image tag
     ↓
[ AWS EKS ]
     |
     |-- Pulls new container version
     |-- Rolls out updated microservice
```
