# Schedule Terragrunt Infrastructure

This repository manages the infrastructure for the Schedule application on Google Cloud Platform (GCP) and Microsoft Azure using Terragrunt. The repository follows a hierarchical structure to organize the configurations and leverage Terragrunt's capabilities.

## Table of Contents

1. [Repository Structure](#repository-structure)
2. [How to Use](#how-to-use)
3. [Expanding the Structure](#expanding-the-structure)

## Repository Structure

### Brief Infrastructure Overview

1. **Root Level (`./terragrunt.hcl`):** Sets up a GCS bucket that will store remote states for the entire infrastructure.

2. **Cloud Level (`./<cloud>/provider.hcl`):** Configure the connection to the specific cloud and inject some common cloud variables.

3. **Environment Level (`./<cloud>/<environment>/env.hcl`):** Customizes common variables for each environment.

4. **Module Level (`./<cloud>/<environment>/<module>/terragrunt.hcl`):** Manages specific resources using modules from the Terraform registry. Inherits variables from the cloud, environment and common configurations.

### Detailed Infrastructure Overview

#### `./terragrunt.hcl`

This file at the root level sets up the GCS remote state for the entire infrastructure. It serves as the entry point for Terragrunt execution below both clouds.

#### `./<cloud>/provider.hcl`

Includes cloud-specific provider configuration. Serves as an entry point for parsing and merging further inputs common to the cloud project.

#### `./<cloud>/_envcommon`

This directory contains common configuration files (`.hcl`) shared among different modules. These files, grouped by subdirectories, include configurations for firewall rules, instances, instance templates, Kubernetes, NAT, networks, PostgreSQL services, and much more.

Refer to these settings as a fundamental attributes that will be used across module resources.

#### `./<cloud>/<environment>/env.hcl`

Contains common variables specific to each environment. This file allows customization of variables for different deployment environments, such as production (`./gcp/prod`) and staging (`./gcp/stage`).

#### `./<cloud>/<environment>/<module>/terragrunt.hcl`

These files manage specific resources using modules from the Terraform registry. Each module-specific Terragrunt configuration file allows injecting environment-specific variables and leverages the hierarchy structure defined in this repository. Note that some modules are grouped with appropriate related ones, so they may be stored at a deeper directory level.

## How to Use

**1. Set up the required GCP credentials**

The recommended way of authenticating Terragrunt with GCP credentials is by using [application-default credentials (ADC)](https://cloud.google.com/docs/authentication/provide-credentials-adc).

**2. Set up Azure credentials**

Create a [service principal with the necessary permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/managed_service_identity). This involves creating an application in Azure Active Directory and assigning it a role with the required permissions.

**Note:** Please adhere to the **Principle of least privilege** when assigning roles to your principal account. It's highly not recommended to attach a more open role than a `Contributor` one.

```bash
az ad sp create-for-rbac --name <SERVICE_PRINCIPAL_NAME> --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

From the following JSON output, export the next variables:

```bash
export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=
export ARM_SUBSCRIPTION_ID=
export ARM_TENANT_ID=
```

**Note:** Even with the `export` command, your credential will persist only in the current Shell execution environment. It's possible to create a BASH script with the functionality of automatic credential data injection, but it should be stored in a fully secure directory path with no higher than `700` script permissions.

**3. Authenticate Vault provider**

The process of authenticating the Vault provider is similar to that of Microsoft Azure. You can use the method described either in our [Custom Vault Module Repository](https://github.com/BlueTeam2/vault) or any method from the [Terraform Vault Provider documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs). 

This repository is capable of managing a separate Vault machine under `./gcp/global/vault` path. You can provision it and other global modules **before** any specific application environment, configure services using Ansible, and then export credentials from it. It's the **recommended** way of setting things up, but you're still free to use other project-specific Vault servers.

**4. Call Terragrunt**

If you want to provision only some part of the infrastructure described under repository infrastructure, then navigate to the specific infrastructure path. If you want to manage the entire architecture, then it will be sufficient to execute Terragrunt-specific commands from the root directory (Where main `terragrunt.hcl` is located). Below is described one of the use-cases as an example.

```bash
# Clone the repository and cd into it
git clone git@github.com:BlueTeam2/terragrunt-live.git && cd terragrunt-live

# From here you're already able to use Terragrunt functionality, although you
# can also navigate to the specific infrastructure part path
cd gcp/stage

# Provision the infrastructure
terragrunt run-all apply

# Wrap it up and destroy all created resources
terragrunt run-all destroy
```

## Expanding the Structure

Most of the Terragrunt modules used in this IaC can be found at the [Terraform Registry](https://registry.terraform.io/). To get detailed information about the exact module, please refer to its documentation. Note that some logical resources are created by corresponding **submodules** (such as `postgresql` instance is created by [postgresql](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest/submodules/postgresql) submodule under the [sql-db](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest) module under [GoogleCloudPlatform](https://registry.terraform.io/namespaces/GoogleCloudPlatform) namespace)

If the new infrastructure component should be added, then give preference to well-known modules [(example)](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest/submodules/postgresql) from the official providers. If some specific features also appear in the module, then please note all the necessary information in this documentation or add corresponding comments to the code.

Always add `mock_outputs` block for used dependencies in order to give `terragrunt plan` functionality the possibility to generate a mocked planning structure. Also, defining necessary attributes in the mock block can help avoid problems with unfetched values on a `terragrunt run-all destroy` command.
