terraform {
  source = "${local.base_source_url}?version=18.1.0"
}

locals {
  base_source_url = "tfr:///GoogleCloudPlatform/sql-db/google//modules/backup"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "service" {
  config_path = "../service"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    instance_name = "mock_name"
  }
}

dependency "bucket" {
  config_path = "../bucket"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    url = "gs://mock_bucket_url"
  }
}

inputs = {
  sql_instance = dependency.service.outputs.instance_name
  export_uri   = dependency.bucket.outputs.url

  backup_retention_time = 33            # A few additional days for safety
  backup_schedule       = "20 04 * * 5" # Every Friday at 4:20 AM
  export_schedule       = "00 05 * * 5" # Every Friday at 5:00 AM
}
