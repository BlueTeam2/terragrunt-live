terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/workload-identity?version=29.0.0"
}

# We need to explicitly initialize `kubernetes` provider in order to create
# a service account inside the application namespace. For those purposes, we
# need to get `host`, `ca_certificate` and `token` values. Though we can get
# `host` and `ca_certificate` through the outputs of `kubernetes-engine` block,
# we still need to include `auth` module to get the `token` value
generate "kubernetes_provider" {
  path      = "kubernetes_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  host                   = "${dependency.kubernetes_auth.outputs.host}"
  cluster_ca_certificate = base64decode("${dependency.cluster.outputs.ca_certificate}")
  token = "${dependency.kubernetes_auth.outputs.token}"
}
EOF
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  name = "kubernetes"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    name           = "mock_name"
    ca_certificate = "mock_ca_certificate"
  }
}

dependency "kubernetes_auth" {
  config_path = "../auth"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    host  = "mock_host"
    token = "mock_token"
  }
}

inputs = {
  name                            = "${local.env}-${local.name}"
  cluster_name                    = dependency.cluster.outputs.name
  workspace                       = "schedule-app"
  automount_service_account_token = true
}
