# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = "RG1"
  location = "East US"
}