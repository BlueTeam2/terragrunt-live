include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/firewall_rules.hcl"
}

locals {
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
  network_name = dependency.network.outputs.network_name

  ingress_rules = [
    {
      name          = "${local.env}-grafana"
      target_tags   = ["grafana"]
      source_ranges = ["0.0.0.0/0"]

      allow = [
        {
          protocol = "tcp"
          ports    = [22, 27875]
        }
      ]
    }
  ]
}
