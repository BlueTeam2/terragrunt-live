generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project     = "${local.project}"
}
EOF
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project          = local.environment_vars.locals.project
}

inputs = merge(
  # Merge common inputs such as `region` and `zone`
  # Note that some modules may require other names for these inputs
  # E.g., google/network module with concrete `subnet_region` input
  local.environment_vars.inputs,
  {
    project_id = "${local.project}"
    project    = "${local.project}" # GCP cloud-router specific
  }
)
