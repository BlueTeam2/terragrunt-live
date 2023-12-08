include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/instance_template.hcl"
  merge_strategy = "deep"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "firewall_rules" {
  config_path = "../firewall_rules"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    firewall_rules_ingress_egress = {
      "stage-mongodb" = {
        target_tags = ["mock_target_tag"]
      }
    }
  }
}

inputs = {
  name_prefix = "${local.env}-mongodb-template"
  tags        = dependency.firewall_rules.outputs.firewall_rules_ingress_egress.stage-mongodb.target_tags

  labels = {
    service = "mongodb"
  }
}
