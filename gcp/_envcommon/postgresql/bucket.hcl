terraform {
  source = "${local.base_source_url}?version=5.0.0"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/cloud-storage/google"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  region           = local.environment_vars.inputs.region
}

inputs = {
  # The name should be unique, so we add a random 8-character string as a suffix
  names    = ["${local.env}-postgresql-backup-${substr(uuid(), 0, 8)}"]
  location = local.region

  force_destroy = {                            # Disable destroy prevention at the Terraform module level
    ("${local.env}-postgresql-backups") = true # Will be managed by a Terragrunt
  }
}
