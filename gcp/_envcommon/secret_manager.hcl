terraform {
  source = "tfr:///GoogleCloudPlatform/secret-manager/google?version=0.1.1"
}

# We don't use the common dependency block here because resources that may
# request a new secret manager potentially can have an uncommon config_path
