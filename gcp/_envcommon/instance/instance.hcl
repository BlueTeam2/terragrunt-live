terraform {
  source = "${local.base_source_url}?version=10.1.1"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/vm/google//modules/compute_instance"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  instance_vars = read_terragrunt_config(find_in_parent_folders("instance.hcl"))
  name          = local.instance_vars.locals.name
}

dependency "instance_template" {
  config_path = "../template"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    self_link = ["mock_instance_template_self_link"]
  }
}

inputs = {
  hostname          = "${local.env}-${local.name}"
  instance_template = dependency.instance_template.outputs.self_link
}
