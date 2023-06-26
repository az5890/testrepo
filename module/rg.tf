# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = "RG"
  location = "East US"
}