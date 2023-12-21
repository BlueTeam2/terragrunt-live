terraform {
  source = "${local.base_source_url}?version=3.2.0"
}

locals {
  base_source_url = "tfr:///terraform-google-modules/address/google"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  project          = local.environment_vars.locals.project

  instance_vars = read_terragrunt_config(find_in_parent_folders("instance.hcl"))
  name          = local.instance_vars.locals.name
}

# When using CE instances, don't forget to specify a subnetwork for them
inputs = {
  names        = ["${local.env}-${local.name}"]
  address_type = "EXTERNAL"

  enable_cloud_dns = true
  dns_project      = local.project
  dns_managed_zone = "smaha"
  dns_domain       = "smaha.top"                    # The GCP `dns` data source doesn't exist, so it can't be fetched
  dns_short_names  = ["${local.env}-${local.name}"] # The DNS name will be <dns_short_name>.<dns_domain>
}
