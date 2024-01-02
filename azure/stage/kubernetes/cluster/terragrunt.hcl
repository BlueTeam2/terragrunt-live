include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/azure/_envcommon/kubernetes/cluster.hcl"
}

prevent_destroy = true # Pet

inputs = {
  net_profile_pod_cidr      = "10.1.0.0/16"
  agents_availability_zones = ["1", "2"]
}
