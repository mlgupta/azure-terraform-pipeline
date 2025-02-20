# environments/test/backend.hcl
resource_group_name   = "terraform-state-rg"
storage_account_name  = "dbstfstatetest"
container_name       = "tfstate"
key                  = "terraform.tfstate"
