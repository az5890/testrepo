# Create a resource group
# resource "azurerm_resource_group" "example" {
#   name     = "recovery-vault-rg1"
#   location = "East US"
# }

# Create the Recovery Services Vault
resource "azurerm_recovery_services_vault" "example" {
  name                = var.recovery_vault_service
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"  # Replace with desired SKU
}


resource "azurerm_backup_policy_vm" "example" {
  name                = "tfex-recovery-vault-policy"
  resource_group_name = azurerm_resource_group.example.name
  recovery_vault_name = azurerm_recovery_services_vault.example.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }
}

# # Create the backup policy
# resource "azurerm_recovery_services_protection_policy" "example" {
#   name                = "backup-policy"
#   resource_group_name = azurerm_resource_group.example.name
#  # vault_name          = azurerm_recovery_services_vault.example.name

#   backup {
#     frequency        = "Daily"
#     retention_days   = 30
#     start_time       = "02:00"
#     time_zone        = "UTC"
#   }
# }

# # Output the vault details
# output "vault_id" {
#   value = azurerm_recovery_services_vault.example.id
# }