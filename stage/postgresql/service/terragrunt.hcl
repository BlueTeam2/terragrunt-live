include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/postgresql.hcl"
}

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
