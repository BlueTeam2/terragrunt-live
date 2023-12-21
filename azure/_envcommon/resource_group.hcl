terraform {
  source = "${local.base_source_url}?version=1.3.0"
}

locals {
  base_source_url = "tfr:///data-platform-hq/resource-group/azurerm"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project
}

inputs = {
  custom_resource_group_name = "${local.env}-${local.project}"
  project                    = local.project
  env                        = local.env
}
