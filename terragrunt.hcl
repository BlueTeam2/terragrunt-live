locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "blue-schedule"
    prefix = "terragrunt/${path_relative_to_include()}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project     = "softseve-blue-team"
}
EOF
}

inputs = merge(
  # Merge common inputs such as `region` and `zone`
  # Note that some modules may require other names for these inputs
  # E.g., google/network module with concrete `subnet_region` input
  local.environment_vars.inputs,
  {
    project_id = "softseve-blue-team"
    project    = "softseve-blue-team" # GCP cloud-router specific
  }
)
