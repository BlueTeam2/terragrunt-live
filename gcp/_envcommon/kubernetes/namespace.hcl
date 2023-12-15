# Note: This module requires authenticated `kubernetes` provider.
# Preferable to use `_envcommon/logical_auth` initializer in you child modules.

terraform {
  source = "${local.base_source_url}?version=0.1.5"
}

locals {
  base_source_url = "tfr:///terraform-module/namespace/kubernetes"
}

inputs = {
  name        = "schedule-app"
  description = "schedule-app-k8s-wi"
}
