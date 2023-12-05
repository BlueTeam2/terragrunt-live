terraform {
  source = "tfr:///terraform-google-modules/vm/google//modules/instance_template?version=10.1.1"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "network" {
  config_path = "../../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    subnets_names = ["mock_subnet_name"]
  }
}

inputs = {
  name_prefix          = "${local.env}-mongodb-template"
  subnetwork           = dependency.network.outputs.subnets_names[0]
  disk_size_gb         = 20
  machine_type         = "e2-micro"
  source_image_project = "ubuntu-os-cloud"
  source_image_family  = "ubuntu-2204-lts"

  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }

  access_config = [
    {
      nat_ip = ""
      network_tier = "Premium"
    }
  ]
}
