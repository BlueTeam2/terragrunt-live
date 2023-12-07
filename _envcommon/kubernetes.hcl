terraform {
  source = "${local.base_source_url}?version=29.0.0"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/kubernetes-engine/google"

  environment_vars         = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env                      = local.environment_vars.locals.environment
  zone                     = local.environment_vars.locals.zone
  kubernetes_instance_type = local.environment_vars.locals.kubernetes_instance_type
}

dependency "network" {
  config_path = "../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    network_name  = "mock_network_name"
    subnets_names = ["mock_subnet_name"]
    subnets_secondary_ranges = [
      [
        {
          range_name = "mock_pods_ip_range"
        },
        {
          range_name = "mock_services_ip_range"
        }
      ]
    ]
  }
}

inputs = {
  name                   = "${local.env}-schedule"
  deletion_protection    = false
  regional               = false
  create_service_account = false
  zones                  = [local.zone]
  network                = dependency.network.outputs.network_name
  subnetwork             = dependency.network.outputs.subnets_names[0]
  ip_range_pods          = dependency.network.outputs.subnets_secondary_ranges[0][0].range_name
  ip_range_services      = dependency.network.outputs.subnets_secondary_ranges[0][1].range_name

  remove_default_node_pool = true
  node_pools = [
    {
      name           = "${local.env}-schedule-pool"
      machine_type   = local.kubernetes_instance_type
      node_locations = local.zone
      node_count     = 2
      autoscaling    = false
      disk_size_gb   = 40
      image_type     = "COS_CONTAINERD"
    },
  ]
}
