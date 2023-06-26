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
}

resource "azurerm_recovery_services_protection_policy_vm" "example" {
  name                = "backup-policy"
  resource_group_name = azurerm_resource_group.example.name
  vault_name          = azurerm_recovery_services_vault.example.name

  backup {
    frequency        = "Daily"
    retention_days   = 30
    start_time       = "2023-06-26T00:00:00"
    time_zone        = "UTC"
  }
}
resource "azurerm_recovery_services_protected_vm" "example" {
  name                = "protected-vm"
  resource_group_name = azurerm_resource_group.example.name
  vault_name          = azurerm_recovery_services_vault.example.name
  source_vm_id        = "/subscriptions/your-subscription-id/resourceGroups/your-vm-rg/providers/Microsoft.Compute/virtualMachines/your-vm-name"
  policy_id           = azurerm_recovery_services_protection_policy_vm.example.id
}
