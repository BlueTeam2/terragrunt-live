include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "logical_auth" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/kubernetes/logical_auth.hcl"
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/kubernetes/namespace.hcl"
}
