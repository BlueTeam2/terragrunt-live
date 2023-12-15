terraform {
  source = "${local.base_source_url}?version=0.1.1"
}

locals {
  base_source_url = "tfr:///GoogleCloudPlatform/secret-manager/google"
}

# We don't use the common dependency block here because resources that may
# request a new secret manager potentially can have an uncommon config_path
