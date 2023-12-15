locals {
  environment              = "stage"
  project                  = "softseve-blue-team"

  # We extract this variable because the inner structure is too complicated to
  # override, even with the deep merging.
  kubernetes_instance_type = "e2-medium" 
}

inputs = {
  region = "us-central1"
  zone   = "us-central1-b"
}
