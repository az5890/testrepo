# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = "3.61.0"
#     }
#   }
# }

# provider "azurerm" {
#   # Configuration options
#   features {
  
#   }
# }


# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = var.vm_resource_group
  location = "East US"
}

# Define the virtual network
resource "azurerm_virtual_network" "example" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Define the subnet
resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# resource "azurerm_subnet" "example1" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# Define the network security group
resource "azurerm_network_security_group" "example" {
  name                = "my-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Define the security rule to allow SSH
resource "azurerm_network_security_rule" "example" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["0.0.0.0/0"]
  destination_address_prefix  = azurerm_subnet.example.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Define the virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  count                       = 3
  name                        = "IN-PIS-P-VM00${count.index}-AAC"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  size                        = "Standard_DS2_v2"
  admin_username              = "adminuser"
  admin_password              = "Password123!"
 # disable_password_authentication = False

 admin_ssh_key {
  username    = "adminuser"
  public_key  = tls_private_key.example_ssh.public_key_openssh
}

  network_interface_ids       = [azurerm_network_interface.example[count.index].id]

   source_image_reference {
    publisher                 = "RedHat"
    offer                     = "RHEL"
    sku                       = "8-gen2"
    version                   = "latest"
  }

  os_disk {
    name                      = "osdisk-${count.index}"
    caching                   = "ReadWrite"
    storage_account_type      = "Standard_LRS"
    disk_size_gb              = 128
  }
    #os_type               = "Linux"
  
  # os_profile {
  #   computer_name             = "myvm${count.index}"
  #   admin_username            = "adminuser"
  #   admin_password            = "Password123!"
  # }


  tags = {
    environment               = "dev"
  }
}

# Define the network interface
resource "azurerm_network_interface" "example" {
  count                       = 3
  name                        = "my-nic-${count.index}"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name

  ip_configuration {
    name                      = "myconfig-${count.index}"
    subnet_id                 = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# #  Enable Microsoft Defender for Cloud
#  resource "azurerm_virtual_machine_extension" "defender" {
#   count                       = 3
#   name                        = "my-defender-extension-${count.index}"
#   virtual_machine_id          = azurerm_linux_virtual_machine.example[count.index].id   
#   publisher                   = "Microsoft.Azure.Security"
#   type                        = "AzureDefenderforServers"
#   type_handler_version        = "latest"
#   auto_upgrade_minor_version  = true
#   settings = <<SETTINGS
#   {
#   "workspaceResourceId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace-id",
#   "apiToken": "my-api-token"
#   }
#   SETTINGS
#  }