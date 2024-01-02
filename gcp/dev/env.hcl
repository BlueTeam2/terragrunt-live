locals {
  environment = "dev"
  project     = "softseve-blue-team"

  # We extract this variable because the inner structure is too complicated to
  # override, even with the deep merging.
  kubernetes_instance_type = "e2-medium"
}

inputs = {
  region = "us-west1"
  zone   = "us-west1-b"
}
