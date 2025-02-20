locals {
  workspace = terraform.workspace
  environment = dirname(dirname(path.cwd))
}

# Resources specific to this workspace
# now1