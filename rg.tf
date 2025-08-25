resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    Environment = var.environment
    Region      = var.rg_location
    Team        = var.team
  }
}
