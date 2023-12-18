# By including this abstract Terragrunt entity, we can easily initialize the
# `kubernetes` provider. Using this approach, we can perform primary Kubernetes
# configurations, such as initializing the appropriate namespace, attaching
# the workload identity to the cluster, etc.

terraform {
  error_hook "expired_kubernetes_token" {
    commands = ["plan", "destroy"]
    execute = [
      "echo",
      "-e",
      "\\e[41m Kubernetes token is expired. Please refresh it using `terragrunt run-all refresh` in ${get_terragrunt_dir()} \\e[0m"
    ]
    on_errors = [
      "Unauthorized",
    ]
  }
}

generate "kubernetes_provider" {
  path      = "kubernetes_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  host                   = "${dependency.kubernetes_auth.outputs.host}"
  cluster_ca_certificate = base64decode("${dependency.cluster.outputs.ca_certificate}")
  token                  = "${dependency.kubernetes_auth.outputs.token}"
}
EOF
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
