terraform {
  source = "${local.base_source_url}?version=17.1.0"
}

locals {
  base_source_url = "tfr:///GoogleCloudPlatform/sql-db/google//modules/postgresql"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

inputs = {
  name                   = "${local.env}-postgres"
  database_version       = "15"
  maintenance_window_day = 7
  enable_default_user    = false
  enable_default_db      = false
  deletion_protection    = false
}
