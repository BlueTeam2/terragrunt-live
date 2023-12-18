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

  ip_secret_name = "${local.env}-mongodb-ip"

  common_labels = {
    app = "schedule"
    env = local.env
  }
}

dependency "mongodb" {
  config_path = "../instance"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    instances_details = "mock_instances_details"
  }
}

inputs = {
  secrets = [
    {
      name                  = local.ip_secret_name
      automatic_replication = "true"
      secret_data           = dependency.mongodb.outputs.instances_details[0].network_interface[0].access_config[0].nat_ip
    }
  ]

  labels = {
    (local.ip_secret_name) = merge(local.common_labels, { type = "ip" })
  }
}
