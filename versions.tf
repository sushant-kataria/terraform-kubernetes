terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "d1fc1672-f56d-4f3d-b6ab-0f725d80bef1"
}

terraform {
  backend "azurerm" {}
}
