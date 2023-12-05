terraform {
  source = "tfr:///terraform-google-modules/vm/google//modules/compute_instance?version=10.1.1"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "instance_template" {
  config_path = "../instance-template"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    self_link = ["mock_instance_template_self_link"]
  }
}

inputs = {
  hostname          = "${local.env}-mongodb"
  instance_template = dependency.instance_template.outputs.self_link
}
