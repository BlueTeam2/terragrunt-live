include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/instance.hcl"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

inputs = {
  hostname = "${local.env}-grafana"
}
