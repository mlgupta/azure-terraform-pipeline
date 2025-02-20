# environments/prod/backend.hcl
resource_group_name   = "terraform-state-rg"
storage_account_name  = "dbstfstateprod"
container_name       = "tfstate"
key                  = "terraform.tfstate"
