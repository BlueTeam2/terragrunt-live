include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/instance/address.hcl"
}

locals {
  instance_vars = read_terragrunt_config(find_in_parent_folders("instance.hcl"))
  name          = local.instance_vars.locals.name
}
