remote_state {
  backend = "gcs"
  config = {
    bucket = "blue-schedule"
    prefix = "terragrunt/${path_relative_to_include()}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
