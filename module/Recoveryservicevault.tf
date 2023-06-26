# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "recovery-vault-rg"
  location = "East US"
}

# Create the Recovery Services Vault
resource "azurerm_recovery_services_vault" "example" {
  name                = "recovery-vault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"  # Replace with desired SKU
}

# Output the vault details
output "vault_id" {
  value = azurerm_recovery_services_vault.example.id
}