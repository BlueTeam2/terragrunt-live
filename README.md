# Schedule Terragrunt Infrastructure

This repository manages the infrastructure for the Schedule application on Google Cloud Platform (GCP) using Terraform and Terragrunt. The repository follows a hierarchical structure to organize the configurations and leverage Terragrunt's capabilities.

## Directory Structure Explanation

#### `./terragrunt.hcl`

This file at the root level manages the GCP provider configuration and sets up GCS remote state for the entire infrastructure. It serves as the entry point for Terragrunt.

#### `./<environment>/env.hcl`

Contains common variables specific to each environment. This file allows customization of variables for different deployment environments such as production (`./prod`) and staging (`./stage`).

#### `./_envcommon`

This directory contains common configuration files (`.hcl`) shared among different modules. These files include configurations for firewall rules, instances, instance templates, Kubernetes, NAT, network, and PostgreSQL.

#### `./<environment>/<module>/terragrunt.hcl`

These files manage specific resources using modules from the Terraform registry. Each module-specific Terragrunt configuration file allows injecting environment-specific variables and leverages the hierarchy structure defined in this repository. Note that some modules are grouped with appropriate related ones, so they can be stored at a deeper directory level.

### Infrastructure Management

1. **Root Level (`./terragrunt.hcl`):** Manages the GCP provider configuration and sets up GCS remote state for the entire infrastructure.

2. **Environment Level (`./<environment>/env.hcl`):** Customizes common variables for each environment.

3. **Module Level (`./<environment>/<module>/terragrunt.hcl`):** Manages specific resources using modules from the Terraform registry. Inherits variables from both the environment and common configurations.

## Usage

1. Set up the required GCP credentials. The recommended way of authenticating Terragrunt with GCP credentials is by using [application-default credentials (ADC)](https://cloud.google.com/docs/authentication/provide-credentials-adc).
2. Navigate to the desired environment directory (e.g., `./prod` or `./stage`).
3. Execute Terragrunt commands to plan and apply infrastructure changes.

### Code Example

```bash
# Switch to the appropriate environment folder
cd stage

# Plan infrastructure deployment
# Note that Terragrunt is only a wrapper above Terraform, so the output may contain inaccuracies
terragrunt run-all plan

# If the output is ok, then apply all modules
terragrunt run-all apply
```

## Module Information & Expanding The Structure

Most of the Terragrunt modules used in this IaC can be found at the [Terraform Registry](https://registry.terraform.io/). To get detailed information about the exact module, please refer to its documentation. Note that some logical resources are created by corresponding **submodules** (such as `postgresql` instance is created by [postgresql](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest/submodules/postgresql) submodule under [sql-db](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest) module under [GoogleCloudPlatform](https://registry.terraform.io/namespaces/GoogleCloudPlatform) organization)

If the new infrastructure component should be added, then give preference to well-known modules from the official providers. If some specific features also appear in the module, then please note all the necessary information in this documentation.

Always add `mock_outputs` block as needed in order to give `terragrunt plan` functionality the possibility to generate at least a mocked planning structure.