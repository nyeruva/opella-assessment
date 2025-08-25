# Subnet for Bastion
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet" # Required name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.dev_vnet.vnet_name # using output from vnet module
  address_prefixes     = var.bastion_address_prefix
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-host-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "bastion-ip-config-${var.environment}"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
  tags = {
    Environment = var.environment
  }
}
