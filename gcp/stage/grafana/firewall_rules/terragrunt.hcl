include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/instance/firewall_rules.hcl"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  instance_vars = read_terragrunt_config(find_in_parent_folders("instance.hcl"))
  name          = local.instance_vars.locals.name
}

inputs = {
  ingress_rules = [
    {
      name          = "${local.env}-${local.name}"
      target_tags   = [local.name]
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
