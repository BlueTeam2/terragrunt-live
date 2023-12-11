locals {
  environment              = "stage"
  project                  = "softseve-blue-team"
  kubernetes_instance_type = "t2a-standard-2"
}

inputs = {
  region = "us-central1"
  zone   = "us-central1-b"
}
