resource "azurerm_resource_group" "cloudfare-azure-prom" {
  name     = "cloudfare-azure-prom"
  location = "West Europe"
}


resource "azurerm_virtual_network" "cloudfare-azure-prom" {
  name                = "cloudfare-azure-prom"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cloudfare-azure-prom.location
  resource_group_name = azurerm_resource_group.cloudfare-azure-prom.name
}

resource "azurerm_subnet" "cloudfare-azure-prom" {
  name                 = "cloudfare-azure-prom-main"
  resource_group_name  = azurerm_resource_group.cloudfare-azure-prom.name
  virtual_network_name = azurerm_virtual_network.cloudfare-azure-prom.name
  address_prefixes     = [
    "10.0.2.0/24"
  ]
}

resource "azurerm_public_ip" "cloudfare-azure-prom-pip" {
  name                = "cloudfare-azure-prom-pip"
  resource_group_name = azurerm_resource_group.cloudfare-azure-prom.name
  location            = azurerm_resource_group.cloudfare-azure-prom.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "cloudfare-azure-prom" {
  name                = "cloudfare-azure-prom-nic"
  location            = azurerm_resource_group.cloudfare-azure-prom.location
  resource_group_name = azurerm_resource_group.cloudfare-azure-prom.name

  ip_configuration {
    name                          = "cloudfare-azure-prom-main"
    subnet_id                     = azurerm_subnet.cloudfare-azure-prom.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudfare-azure-prom-pip.id
  }
}

resource "azurerm_network_security_group" "cloudfare-azure-prom" {
  name                = "cloudfare-azure-prom"
  location            = azurerm_resource_group.cloudfare-azure-prom.location
  resource_group_name = azurerm_resource_group.cloudfare-azure-prom.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = [
      "20.224.236.82"
    ]
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.cloudfare-azure-prom.private_ip_address
  }
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "NodeExporter"
    priority                   = 101
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = [
      "20.224.236.82"
    ]
    destination_port_range     = "9100"
    destination_address_prefix = azurerm_network_interface.cloudfare-azure-prom.private_ip_address
  }
}

resource "azurerm_linux_virtual_machine" "cloudfare-azure-prom" {
  name                = "cloudfare-azure-prom-machine"
  resource_group_name = azurerm_resource_group.cloudfare-azure-prom.name
  location            = azurerm_resource_group.cloudfare-azure-prom.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  custom_data         = base64encode(data.template_cloudinit_config.ubuntu.rendered)

  network_interface_ids = [
    azurerm_network_interface.cloudfare-azure-prom.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    prometheus = "true"
    node_exporter = "true"
    public_ip = "${azurerm_public_ip.cloudfare-azure-prom-pip.ip_address}"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
