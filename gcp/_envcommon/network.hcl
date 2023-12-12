terraform {
  source = "${local.base_source_url}?version=8.0.0"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/network/google"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  region           = local.environment_vars.inputs.region
}

inputs = {
  network_name = "${local.env}-schedule"

  subnets = [
    {
      subnet_name   = "${local.env}-general-subnet-01"
      subnet_ip     = "10.20.0.0/17"
      subnet_region = local.region
    },
  ]

  secondary_ranges = {
    ("${local.env}-general-subnet-01") = [
      {
        range_name    = "pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}
