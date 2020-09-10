terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.26.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=1.13.1"
    }
  }

  required_version = "=0.13.2"
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"

  features {}
}

module "resource_group_1" {
  source = "./resource_group_1"
}

module "resource_group_2" {
  source = "./resource_group_2"
}
