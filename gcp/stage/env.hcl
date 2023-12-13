locals {
  environment              = "stage"
  project                  = "softseve-blue-team"
  kubernetes_instance_type = "e2-medium"
}

inputs = {
  region = "us-central1"
  zone   = "us-central1-b"
}
