resource "azurerm_resource_group" "sql_rg" {
  name     = "sql-mi-rg"
  location = "Australia East"
}

resource "azurerm_virtual_network" "sql_vnet" {
  name                = "sql-mi-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.sql_rg.location
  resource_group_name = azurerm_resource_group.sql_rg.name
}

resource "azurerm_subnet" "sql_mi_subnet" {
  name                 = "sql-mi-subnet"
  resource_group_name  = azurerm_resource_group.sql_rg.name
  virtual_network_name = azurerm_virtual_network.sql_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
  delegation {
    name = "sqlmi_delegation"
    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_mssql_managed_instance" "sql_mi" {
  name                         = "basic-sql-mi"
  resource_group_name          = azurerm_resource_group.sql_rg.name
  location                     = azurerm_resource_group.sql_rg.location
  subnet_id                    = azurerm_subnet.sql_mi_subnet.id
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssw0rd1234!" # Use a secure method for secrets in production
  sku_name                     = "GP_Gen5"
  vcores = "4"
  storage_size_in_gb           = 32
  license_type                 = "LicenseIncluded"
}

# Note: For production, use secure secret management for