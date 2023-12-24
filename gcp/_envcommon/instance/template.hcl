terraform {
  source = "${local.base_source_url}?version=10.1.1"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/vm/google//modules/instance_template"

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

  # IMPORTANT NOTE: Outputs from a `firewall_rules` module are essentially
  # entire resources that are managed by an underlying `for_each` directive.
  # Because of this, it's impossible to set proper mock outputs in place of them
  # (The resources may not exist, so may not be present in the module output).
  # Terraform's `try` function was used to handle this situation
}

inputs = {
  name_prefix = "${local.env}-${local.name}-template"
  tags        = try(values(dependency.firewall_rules.outputs.firewall_rules_ingress_egress)[0].target_tags, ["mock_tag"])

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
