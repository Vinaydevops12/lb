data "azurerm_subnet" "example" {
  for_each = var.VM
  name                 = each.value.subnet-name
  virtual_network_name = "VNET1"
  resource_group_name  = "LB-RG"
}


resource "azurerm_network_interface" "NIC" {
  for_each            = var.VM
  name                = each.value.nic-name
  location            = each.value.location
  resource_group_name = each.value.rg-name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_linux_virtual_machine" "VM" {
  for_each            = var.VM
  name                = each.value.vm-name
  resource_group_name = each.value.rg-name
  location            = each.value.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Vinay@123456"
  network_interface_ids = [
    azurerm_network_interface.NIC[each.key].id,
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
disable_password_authentication = false
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}