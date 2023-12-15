terraform {
  source = "${local.base_source_url}?version=29.0.0"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/auth"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    name     = "mock_name"
    location = "mock_location"
  }
}

inputs = {
  cluster_name = dependency.cluster.outputs.name
  location     = dependency.cluster.outputs.location
}
