include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/vault/secrets.hcl"
}

dependency "postgresql" {
  config_path = "../service"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    instance_first_ip_address = "mock_instance_first_ip_address"
  }
}

inputs = {
  secrets_data = {
    postgresql = {
      "ip" = dependency.postgresql.outputs.instance_first_ip_address
    }
  }
}
