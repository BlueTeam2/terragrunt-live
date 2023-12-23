include "root" {
  path = find_in_parent_folders()
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/gcp/_envcommon/vault/secrets.hcl"
}

dependency "mongodb" {
  config_path = "../instance"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    instances_details = [
      {
        network_interface = [
          {
            access_config = [
              {
                nat_ip = "mock_nat_ip"
              }
            ]
          }
        ]
      }
    ]
  }
}

inputs = {
  secrets_data = {
    mongodb = {
      "ip" = dependency.mongodb.outputs.instances_details[0].network_interface[0].access_config[0].nat_ip
    }
  }
}
