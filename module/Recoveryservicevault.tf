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
  name     = "RG001"
  location = "East US"
}

resource "azurerm_recovery_services_vault" "example" {
  name                = "recovery-vault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"
}

resource "azurerm_recovery_services_protected_vm" "example" {
  name                = "protected-vm"
  resource_group_name = azurerm_resource_group.example.name
  vault_name          = azurerm_recovery_services_vault.example.name
  source_vm_id        = "/subscriptions/your-subscription-id/resourceGroups/your-vm-rg/providers/Microsoft.Compute/virtualMachines/your-vm-name"

  backup_policy {
    schedule_policy {
      frequency_type = "Daily"
      start_time     = "2023-06-26T00:00:00"
      retention_daily {
        count = 30
      }
    }
  }
}

