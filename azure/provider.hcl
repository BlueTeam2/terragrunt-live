generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = merge(
  # Merge common environment inputs such as `location`
  # Note that some modules may require other names for these inputs
  local.environment_vars.inputs
)
