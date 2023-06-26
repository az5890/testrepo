terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  
  }
}


# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = "RG"
  location = "East US"
}