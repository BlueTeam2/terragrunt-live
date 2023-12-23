terraform {
  source = "${local.base_source_url}?ref=v1.0.0"
}

locals {
  base_source_url = "git::https://github.com/BlueTeam2/vault//modules/engine"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

inputs = {
  engine = "${local.env}_schedule"
}
