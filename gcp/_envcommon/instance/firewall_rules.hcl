terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/firewall-rules?version=8.1.0"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  instance_vars = read_terragrunt_config(find_in_parent_folders("instance.hcl"))
  name          = local.instance_vars.locals.name
}

dependency "network" {
  config_path = "../../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    network_name = "mock_network_name"
  }
}

# Because even deep mering strategy will not allow us to properly inject
# allowed tags, we should define the input block manually in each submodule
inputs = {
  network_name = dependency.network.outputs.network_name
}
