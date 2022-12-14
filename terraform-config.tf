terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "infra-backend"
    storage_account_name = "terraformbackendinfra"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# provider "azurerm" {
#   alias                         = "test-sub"
#   subscription_id = "fabf54e7-fc37-4c80-9d84-bd626f3c2823"
#   tenant_id              = "3767d0e1-2c4b-461c-867e-7668ab0d7b06"
#   features {}
# }

# provider "azurerm" {
#   alias                         = "prod-sub"
#   subscription_id = "fabf54e7-fc37-4c80-9d84-bd626f3c2823"
#   tenant_id              = "3767d0e1-2c4b-461c-867e-7668ab0d7b06"
#   features {}
# }
