# Create an Azure Firewall
resource "azurerm_firewall" "example" {
  name                = "example-firewall"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "Firewall Standard"
  threat_intel_mode   = "Alert"
  public_ip_address_id = azurerm_public_ip.firewall_public_ip.id

  ip_configuration {
    name                 = "FirewallIPConfig"
    subnet_id            = "/subscriptions/75b7d327-76ca-4c19-a635-b6dc8ca1a365/resourceGroups/RG04/providers/Microsoft.Network/virtualNetworks/Git-Runner/subnets/default"
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
}
