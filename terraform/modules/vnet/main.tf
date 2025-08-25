#Azure Generic vNet Module
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags = {
    Environment = var.environment
    Region      = var.location
    Team        = var.team
  }
}

# Multiple subnets created based on the list of subnet address prefixes
resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_address_prefixes)
  name                 = "subnet${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.subnet_address_prefixes, count.index)]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [azurerm_subnet.subnets]
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  count                     = length(var.subnet_address_prefixes)
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
