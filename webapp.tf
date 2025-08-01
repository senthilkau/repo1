resource "azurerm_resource_group" "webapp_rg" {
  name     = "webapp-rg"
  location = "Australia East"
}

resource "azurerm_app_service_plan" "webapp_plan" {
  name                = "webapp-service-plan"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_web_app" "webapp" {
  name                = "basic-webapp"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  app_service_plan_id = azurerm_app_service_plan.webapp_plan.id

  site_config {
    scm_type = "LocalGit"
  }

  https_only = true
}

# No public IP is exposed by default for Azure Web