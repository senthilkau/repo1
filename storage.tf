# 1. Create a resource group for the storage account
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "australiaeast"
}

# 2. Generate a random suffix to ensure unique storage account name
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# 3. Instantiate your private module
module "storage" {
  source  = "app.terraform.io/senthilkau/storage-account/azurerm"
  version = "~> 0.1.6"
  name                     = azurerm_storage_account.sa.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  prefix                   = "{random_string.suffix.result}" # <-- Use a random suffix
}

# 4. Optional: expose outputs
output "storage_account_id" {
  value = module.storage.storage_account_id
}

output "primary_blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}
