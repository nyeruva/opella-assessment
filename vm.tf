# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  count               = length(var.vnet_subnet_prefixes)
  name                = "${var.vm_name}${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  # SSH Key authentication
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    Environment = var.environment
  }

}
