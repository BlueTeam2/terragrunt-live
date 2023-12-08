locals {
  environment              = "stage"
  kubernetes_instance_type = "e2-medium"
}

inputs = {
  region = "us-central1"
  zone   = "us-central1-b"
}
