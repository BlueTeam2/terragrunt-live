include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/postgresql.hcl"
}

prevent_destroy = false # Pet

inputs = {
  ip_configuration = {
    authorized_networks = [
      {
        name  = "allow-from-anywhere"
        value = "0.0.0.0/0"
      }
    ]
  }
}
