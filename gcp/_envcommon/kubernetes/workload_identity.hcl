# Note: This module requires authenticated `kubernetes` provider.
# Preferable to use `_envcommon/logical_auth` initializer in a child modules.

terraform {
  source = "${local.base_source_url}?version=29.0.0"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/workload-identity"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  name = "kubernetes"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    name           = "mock_name"
    ca_certificate = "U21haGEgVG9w" # Base64 mock
  }
}

dependency "namespace" {
  config_path = "../namespace"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    name = "mock_name"
  }
}

inputs = {
  name                            = "${local.env}-${local.name}"
  cluster_name                    = dependency.cluster.outputs.name
  namespace                       = dependency.namespace.outputs.name
  automount_service_account_token = true
  roles = [
    "roles/secretmanager.viewer",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.workloadIdentityUser",
    "roles/iam.serviceAccountUser",
    "roles/secretmanager.secretAccessor"
  ]
}
