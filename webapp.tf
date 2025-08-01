resource "azurerm_resource_group" "webapp_rg" {
  name     = "webapp-rg"
  location = "Australia East"
}

resource "azurerm_app_service_plan" "webapp_plan" {
  name                = "webapp-service-plan"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  kind                = "Linux"
  reserved = "true"  # Indicates a Linux App Service Plan
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "basic-linux-webapp"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  service_plan_id     = azurerm_app_service_plan.webapp_plan.id

  site_config {
    always_on = true
  }

  https_only = true
}

# No public IP is exposed by default for Azure Web Apps