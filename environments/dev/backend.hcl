# environments/dev/backend.hcl
resource_group_name   = "terraform-state-rg"
storage_account_name  = "dbstfstatedev"
container_name       = "tfstate"
key                  = "terraform.tfstate"
