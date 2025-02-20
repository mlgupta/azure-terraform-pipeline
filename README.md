# Azure Pipeline for Terraform Infrastructure Management

An opinionated Azure Pipeline implementation for Terraform that supports multiple environments, workspaces, and CI/CD pipelines.

## Overview

This project contains two separate pipelines:
- CI Pipeline (`azure-pipeline-ci.yml`): Triggered for each PR against the `main` branch
- CD Pipeline (`azure-pipeline-cd.yml`): Can only be invoked against the `main` branch and deploys changes selectively based on modified workspaces

## Project Structure

```
.
├── README.md
├── azure-pipelines-cd.yml
├── azure-pipelines-ci.yml
├── environments
│   ├── dev
│   │   ├── backend.hcl
│   │   └── workspaces
│   │       ├── compute
│   │       │   ├── backend.tf
│   │       │   └── main.tf
│   │       └── networking
│   │           ├── backend.tf
│   │           └── main.tf
│   ├── prod
│   │   ├── backend.hcl
│   │   └── workspaces
│   │       ├── compute
│   │       │   ├── backend.tf
│   │       │   └── main.tf
│   │       └── networking
│   │           ├── backend.tf
│   │           └── main.tf
│   └── test
│       ├── backend.hcl
│       └── workspaces
│           ├── compute
│           │   ├── backend.tf
│           │   └── main.tf
│           └── networking
│               ├── backend.tf
│               └── main.tf
└── modules
```

The `environments` directory contains folders for each environment (`dev`, `test`, `prod`), with multiple workspaces under each environment.

## Setup Instructions

### 1. State File Configuration

First, create the necessary Azure resources for state storage:

```bash
# Create resource group
az group create --name terraform-state-rg --location eastus

# Create storage accounts
az storage account create --name dbstfstatedev --resource-group terraform-state-rg --sku Standard_LRS
az storage account create --name dbstfstatetest --resource-group terraform-state-rg --sku Standard_LRS
az storage account create --name dbstfstateprod --resource-group terraform-state-rg --sku Standard_LRS

# Create containers
for env in dev test prod; do
    az storage container create --name tfstate --account-name dbstfstate$env
done
```

Configure the backend for each environment. Example for test environment (`environments/test/backend.hcl`):

```hcl
resource_group_name  = "terraform-state-rg"
storage_account_name = "dbstfstatetest"
container_name      = "tfstate"
key                = "terraform.tfstate"
```

Initialize workspaces for each component:

```bash
# Navigate to component directory
cd environments/dev/workspaces/networking
terraform init
terraform workspace new networking

cd ../compute
terraform init
terraform workspace new compute

cd ../database
terraform init
terraform workspace new database
```

### 2. Azure DevOps Pipeline Setup

1. Create Service Connections:
   - Navigate to Project Settings > Service Connections
   - Create connections for each environment
   - Name them: `dev-service-connection`, `test-service-connection`, `prod-service-connection`

2. Create Variable Group:
   - Navigate to Pipelines > Library
   - Create group: `terraform-var-group`
   - Add required variables:
     - `ARM_CLIENT_ID`
     - `ARM_CLIENT_SECRET`
     - `ARM_SUBSCRIPTION_ID`
     - `ARM_TENANT_ID`

### 3. Pipeline Configuration

Create the pipelines using the provided YAML files:
- `azure-pipeline-ci.yml`
- `azure-pipeline-cd.yml`

### 4. Branch Policies

Configure branch policies for the main branch:
1. Navigate to Repos > Branches
2. Select the main branch
3. Configure:
   - Build validation
   - Required reviewers
   - Minimum number of reviewers requirement