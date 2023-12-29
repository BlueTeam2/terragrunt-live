terraform {
  source = "${local.base_source_url}?version=7.5.0"
}

locals {
  base_source_url = "tfr:///Azure/aks/azurerm"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

dependency "resource_group" {
  config_path = "../../resource_group"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    name = "mock_name"
  }
}

inputs = {
  prefix                        = local.env
  resource_group_name           = dependency.resource_group.outputs.name
  admin_username                = null
  azure_policy_enabled          = true
  cluster_name                  = "${local.env}-schedule"
  public_network_access_enabled = false
  identity_type                 = "SystemAssigned"

  net_profile_pod_cidr              = "10.1.0.0/16" # Override at the environment
  private_cluster_enabled           = true
  rbac_aad                          = true
  rbac_aad_managed                  = true
  role_based_access_control_enabled = true

  tags = {
    app = "schedule"
    env = local.env
  }
}
