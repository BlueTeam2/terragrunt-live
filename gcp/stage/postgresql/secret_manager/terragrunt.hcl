include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/secret_manager.hcl"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  ip_secret_name       = "${local.env}-postgresql-ip"
  password_secret_name = "${local.env}-postgresql-password"

  common_labels = {
    app = "schedule"
    env = local.env
  }
}

dependency "postgresql" {
  config_path = "../service"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    instance_first_ip_address = "mock_instance_first_ip_address"
    generated_user_password   = "mock_generated_user_password"
  }
}

inputs = {
  secrets = [
    {
      name                  = local.ip_secret_name
      automatic_replication = "true"
      secret_data           = dependency.postgresql.outputs.instance_first_ip_address
    },
    {
      name                  = local.password_secret_name
      automatic_replication = "true"
      secret_data           = dependency.postgresql.outputs.generated_user_password
    }
  ]

  labels = {
    (local.ip_secret_name)       = merge(local.common_labels, { type = "ip" })
    (local.password_secret_name) = merge(local.common_labels, { type = "password" })
  }
}
