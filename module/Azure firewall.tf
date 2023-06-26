# provider "azurerm" {
#   features {}
# }

# resource "azurerm_resource_group" "example" {
#   name     = "RG1"
#   location = "East US"
# }

# resource "azurerm_virtual_network" "example" {
#   name                = "my-virtual-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
# }

# resource "azurerm_subnet" "example" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.0.0/24"]
# }

resource "azurerm_public_ip" "example" {
  name                = "my-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard" 
}

resource "azurerm_bastion_host" "example" {
  name                = "my-bastion"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
#  subnet_id           = azurerm_subnet.example.id
# public_ip_address_id = azurerm_public_ip.example.id

ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.example1
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

output "bastion_hostname" {
  value       = azurerm_bastion_host.example.dns_name
  description = "Hostname of the Azure Bastion"
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.example.ip_address
  description = "Public IP address of the Azure Bastion"
}



