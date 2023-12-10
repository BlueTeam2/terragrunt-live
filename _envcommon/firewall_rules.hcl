terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/firewall-rules?version=8.1.0"
}

# We don't use the common dependency block here because resources that may
# request a new firewall rule can potentially have an uncommon config_path
