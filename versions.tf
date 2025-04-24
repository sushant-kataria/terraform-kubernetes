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
  subscription_id = "202d4be6-e0dd-4b9e-84b7-e235d53271a8"
}

terraform {
  backend "azurerm" {}
}
