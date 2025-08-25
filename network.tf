module "dev_vnet" {
  source = "./terraform/modules/vnet"
  # source              = "Azure/vnet/azurerm"
  vnet_name               = var.vnet_name
  resource_group_name     = var.rg_name
  location                = var.rg_location
  address_space           = var.vnet_address_space
  subnet_address_prefixes = var.vnet_subnet_prefixes
  environment             = var.environment
  team                    = var.team
  nsg                     = var.nsg

  depends_on = [azurerm_resource_group.rg]
}

# NIC without Public IP
resource "azurerm_network_interface" "nic" {
  count               = length(var.vnet_subnet_prefixes)
  name                = "example-nic${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal${count.index + 1}"
    subnet_id                     = module.dev_vnet.subnet_ids[count.index] # using output from vnet module
    private_ip_address_allocation = "Dynamic"
    # Notice: no public_ip_address_id here
  }
}
