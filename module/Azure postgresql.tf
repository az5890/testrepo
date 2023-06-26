#Azure DB
resource "azurerm_postgresql_server" "example" {
  name                = "my-postgres-server03"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "GP_Gen5_8"
  storage_mb          = 5120
  version             = "11"
  administrator_login = "myadmin"
  administrator_login_password = "Password1234!"  # Replace with your own password
  ssl_enforcement_enabled = "true"
  ssl_minimal_tls_version_enforced = "TLS1_2"
  }

#availability zone
locals {
  zones = toset(["1","2","3"])
}
 
resource "azurerm_postgresql_firewall_rule" "example" {
  name                = "allow-client-ip"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  start_ip_address    = "10.0.0.0"
  end_ip_address      = "10.0.255.255"
}

resource "azurerm_postgresql_database" "example" {
  name                = "my-database"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

