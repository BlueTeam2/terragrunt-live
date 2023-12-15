terraform {
  source = "tfr:///terraform-google-modules/vm/google//modules/instance_template?version=10.1.1"
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
    subnets_names = ["mock_subnet_name"]
  }
}

dependency "firewall_rules" {
  config_path = "../firewall_rules"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    firewall_rules_ingress_egress = {
      "mock_environment_service_rule" = {
        target_tags = ["mock_target_tag"]
      }
    }
  }
}

inputs = {
  name_prefix = "${local.env}-${local.name}-template"
  tags        = values(dependency.firewall_rules.outputs.firewall_rules_ingress_egress)[0].target_tags

  labels = {
    app     = "schedule"
    env     = local.env
    service = local.name
  }

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
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
  ]
}
