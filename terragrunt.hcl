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
  region      = "us-central1"
}
EOF
}

inputs = merge(
  {
    project_id = "softseve-blue-team"
  }
)
