terraform {
  source = "${local.base_source_url}?version=6.0.2"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/cloud-router/google"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "network" {
  config_path = "../../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    network_name = "mock_network_name"
  }
}

inputs = {
  name    = "${local.env}-k8s-router"
  network = dependency.network.outputs.network_name

  nats = [
    {
      name = "${local.env}-k8s-nat"
    }
  ]
}
