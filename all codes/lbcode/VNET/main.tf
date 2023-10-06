resource "azurerm_network_security_group" "example" {
  name                = "example-security-group"
  location            = "West Europe"
  resource_group_name = "LB-RG"
}

resource "azurerm_virtual_network" "VNET" {
  name                = "VNET1"
  location            = "West Europe"
  resource_group_name = "LB-RG"
  address_space       = ["10.0.0.0/16"]
  #

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "TEST"
  }
}