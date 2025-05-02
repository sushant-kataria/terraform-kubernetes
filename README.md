# Terraform AKS Project

This project automates the deployment of an Azure Kubernetes Service (AKS) cluster with supporting resources, including a resource group, Azure Container Registry (ACR), and virtual network, using Terraform for infrastructure as code and Azure DevOps for CI/CD. The modular structure includes separate modules for each major resource, sourced from a Bitbucket repository. This README provides detailed instructions to set up, build, and test the project.

## Getting Started

### Installation Process

To set up the project, install the following tools:

1. **Terraform**:
   - Download from [Terraform Downloads](https://www.terraform.io/downloads.html).
   - The project uses AzureRM provider version 4.26.0, compatible with recent Terraform versions. Install the latest version (1.5.3 as of May 2025) for optimal compatibility and security.
   - Verify installation with `terraform --version`.

2. **Azure CLI**:
   - Install from [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to authenticate and manage Azure resources.
   - Log in with `az login` and ensure your subscription has permissions to create resource groups, ACR, virtual networks, and AKS clusters.

3. **Git**:
   - Install from [Git Downloads](https://git-scm.com/downloads) for cloning repositories and version control.

### Software Dependencies

- **Terraform**: No specific version is required, but it must support AzureRM provider 4.26.0. The latest version (1.5.3) is recommended.
- **AzureRM Provider**: Version 4.26.0 is specified in `versions.tf`. Initialized via `terraform init`.
- **Azure Subscription**: Requires permissions to create resource groups, ACR, virtual networks, and AKS clusters. Verify via the Azure portal.
- **Azure DevOps**: Needed for CI/CD pipeline setup. Create a project at [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/).
- **Bitbucket Access**: Modules are sourced from a Bitbucket repository (`https://bitbucket.org/skataria21/terraformaks.git` at commit `371186f8419c36d57eac750b32c02c34a56e8e93`). Ensure access or use local module copies.

### Latest Releases

- **Terraform**: Latest version is 1.5.3 (May 2025). Check updates at [Terraform Releases](https://github.com/hashicorp/terraform/releases).
- **AzureRM Provider**: Uses version 4.26.0; latest is 4.27.0. See [AzureRM Provider Releases](https://releases.hashicorp.com/terraform-provider-azurerm/).

### API References

The project uses the following AzureRM provider resources:

- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)
- [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
- [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
- [azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
- [azurerm_kubernetes_cluster_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool)
- [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)

## Build and Test

### Setting Up the CI/CD Pipeline

The project uses Azure DevOps for CI/CD automation. Follow these steps:

1. **Create an Azure DevOps Project**:
   - Navigate to [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/) and create a project.
   - Initialize a repository with the Terraform code.

2. **Configure Service Connections**:
   - Create an Azure Resource Manager (ARM) service connection named `terraform-spn-akspipeline` with permissions to manage Azure resources.
   - If using Bitbucket modules, create a Bitbucket service connection.

3. **Set Up Variable Groups**:
   - Create a variable group `bitbucket-auth` with Bitbucket credentials.

4. **Import the Pipeline**:
   - Go to **Pipelines** > **New Pipeline**, select your repository, and import `azure-pipelines.yml`.

5. **Configure Triggers**:
   - Set triggers for pushes to all branches and pull requests to `main`.

### Running the Pipeline

- Trigger the pipeline manually or via configured triggers.
- Monitor stages:
  - **TerraformInit**: Initializes Terraform with the Azure backend (`backend.conf`).
  - **TerraformValidate**: Runs `terraform validate` to check syntax.
  - **TerraformPlan**: Generates an execution plan with `terraform plan`.
  - **TerraformApply**: Applies changes for `main` or specific branches (`terraforminityml-edited-online-with-bitb-1746057997088`).
  - **TerraformDestroy**: Destroys resources under the same branch conditions.

### Testing Locally

To test locally:

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```
   This downloads providers and modules, using `backend.conf` for state storage.

3. Validate configuration:
   ```bash
   terraform validate
   ```

4. Preview changes:
   ```bash
   terraform plan
   ```

5. Apply changes (optional, creates real resources):
   ```bash
   terraform apply
   ```

### Project Structure

The project includes root files and modules:

| File/Folder | Description |
|-------------|-------------|
| `azure-pipelines.yml` | Defines Azure DevOps pipeline with stages for init, validate, plan, apply, and destroy. |
| `backend.conf` | Configures Azure backend for state storage (resource group `NEWRG`, storage account `azurekssvc21`). |
| `main.tf` | Defines resources using modules for resource group, ACR, network, and AKS, with role assignments. |
| `outputs.tf` | Outputs `kubelet_identity` from AKS module. |
| `terraform.tfvars` | Sets default values for variables (e.g., resource group `AKS1`, AKS cluster `demoaks`). |
| `variables.tf` | Declares variables for resource group, ACR, AKS, and network settings. |
| `versions.tf` | Specifies AzureRM provider version 4.26.0 and subscription ID. |
| `modules/acr` | Module for creating ACR, with `main.tf`, `outputs.tf`, and `variables.tf`. |
| `modules/aks` | Module for AKS cluster, with potential bug in default node pool settings. |
| `modules/network` | Module for virtual network and subnets. |
| `modules/resource_group` | Module for resource group creation. |

### Important Considerations

- **Backend Setup**:
  - Ensure Azure resources in `backend.conf` exist:
    - Resource group: `NEWRG`
    - Storage account: `azurekssvc21`
    - Container: `terraformstate`
  - Create these via Azure portal or CLI if needed.

- **Module Access**:
  - Modules are sourced from `https://bitbucket.org/skataria21/terraformaks.git` at commit `371186f8419c36d57eac750b32c02c34a56e8e93`. Verify access or use local copies by updating `main.tf` source paths.

- **AKS Module Bug**:
  - In `modules/aks/main.tf`, the default node pool incorrectly uses `var.user_node_pool` for auto-scaling settings. Update to `var.system_node_pool`:
    ```hcl
    default_node_pool {
      ...
      auto_scaling_enabled = var.system_node_pool.enable_auto_scaling
      min_count            = var.system_node_pool.min_count
      max_count            = var.system_node_pool.max_count
      ...
    }
    ```

- **Security**:
  - Store sensitive data (e.g., subscription ID, principal ID) in Azure DevOps variables or Azure Key Vault.

## Resource Summary

| Resource Type         | Name/ID                     | Description                                      |
|-----------------------|-----------------------------|--------------------------------------------------|
| Resource Group        | `AKS1`                      | Organizes all resources.                         |
| ACR                   | `demoakscr2111`             | Stores container images, Standard SKU.           |
| VNet                  | `aks-vnet`                  | Address space `10.0.0.0/16`.                     |
| Subnet (AKS)          | `aks-subnet`                | Address prefix `10.0.1.0/24`.                    |
| Subnet (Endpoints)    | `endpoints-subnet`          | Address prefix `10.0.2.0/24`.                    |
| AKS Cluster           | `demoaks`                   | Version 1.30.0, system and user node pools.      |

## Conclusion

This project provides a robust setup for deploying an AKS cluster with Terraform and Azure DevOps. By following the installation, setup, and testing steps, users can recreate the infrastructure. Address the AKS module bug and verify Azure and Bitbucket access for a smooth deployment.