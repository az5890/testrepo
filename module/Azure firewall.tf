resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "my-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "my-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_firewall" "example" {
  name                = "my-firewall"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_tier            = "Standard"
}

resource "azurerm_firewall_application_rule_collection" "example" {
  name                = "my-application-rule-collection"
  resource_group_name = azurerm_resource_group.example.name
  firewall_name       = azurerm_firewall.example.name

  rule {
    name                  = "allow-http-https"
    description           = "Allow HTTP and HTTPS traffic from any source to any destination"
    protocol              = "Http"
    source_addresses      = ["*"]
    destination_addresses = ["*"]
    target_fqdns          = []
    fqdn_tags             = []
  }
}

resource "azurerm_firewall_network_rule_collection" "example" {
  name                = "my-network-rule-collection"
  resource_group_name = azurerm_resource_group.example.name
  firewall_name       = azurerm_firewall.example.name

  rule {
    name                  = "allow-http-https"
    description           = "Allow HTTP and HTTPS traffic from any source to any destination"
    protocols             = ["TCP"]
    source_addresses      = ["*"]
    destination_addresses = ["*"]
    destination_ports     = ["80", "443"]
  }
}

output "firewall_private_ip" {
  value       = azurerm_firewall.example.ip_configuration[0].private_ip_address
  description = "Private IP address of the Azure Firewall"
}