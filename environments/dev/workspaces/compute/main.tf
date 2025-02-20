locals {
  workspace = terraform.workspace
  environment = dirname(dirname(path.cwd))
}

# Resources specific to this workspace
# Let us see now12