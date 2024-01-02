include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/instance/instance.hcl"
}

prevent_destroy = true # Pet

dependency "network" {
  config_path = "../../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    subnets_names = ["mock_subnet_name"]
  }
}

dependency "address" {
  config_path = "../address"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    addresses = ["mock_ip"]
  }
}

inputs = {
  subnetwork = dependency.network.outputs.subnets_names[0] # Necessary for the static IP

  access_config = [
    {
      nat_ip       = dependency.address.outputs.addresses[0]
      network_tier = "PREMIUM"
    }
  ]
}
