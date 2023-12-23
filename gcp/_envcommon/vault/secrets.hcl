terraform {
  source = "${local.base_source_url}?ref=v1.0.0"
}

locals {
  base_source_url = "git::https://github.com/BlueTeam2/vault//modules/secrets"
}

dependency "engine" {
  config_path = "../../vault_engine"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    engine = "mock_engine"
  }
}

inputs = {
  engine = dependency.engine.outputs.engine
}
