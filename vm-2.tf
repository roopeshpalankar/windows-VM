resource "azurerm_virtual_network" "mycelvirtualnetwork"{
    name="celvirtualnetwork"
    address_space=["10.255.108.0/22"]
    location="eastus"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    tags{
        environment="Windows"
    }
}
resource "azurerm_subnet" "mycelsubnet"{
   name="celsubnet" 
    address_prefix="10.255.109.0/24"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    virtual_network_name="${azurerm_virtual_network.mycelvirtualnetwork.name}"
    }
    resource "azurerm_subnet" "mycelsubnet-2"{
   name="celsubnet-2" 
    address_prefix="10.255.108.0/24"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    virtual_network_name="${azurerm_virtual_network.mycelvirtualnetwork.name}"
    }

resource "azurerm_network_security_group" "mycelnsg"{
    name="celnsg"
    location="eastus"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"

    security_rule{
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule{
        name                        ="RDP"
        priority                    ="1002"
        direction                   ="Inbound"
        access                      ="allow"
        protocol                    ="TCP"
        source_port_range           ="*"
        destination_port_range      ="3389"
        source_address_prefix       ="*"
        destination_address_prefix  ="*"
    }
    
    tags{
            environment="Windows"
    }
}
resource "azurerm_public_ip" "mycelpublicip-2"{
    name="celpublicip-2"
    location="eastus"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    public_ip_address_allocation="dynamic"
    
    tags{
        environment="Windows"
    }
}
resource "azurerm_public_ip" "mycelpublicip-3"{
    name="celpublicip-3"
    location="eastus"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    public_ip_address_allocation="dynamic"
    
    tags{
        environment="Windows"
    }
}
resource "random_id"    "randomid"{
    keepers = {
        resource_group = "${azurerm_resource_group.mycelgroup.name}"
    }
    byte_length = 8
}

resource    "azurerm_network_interface" "mycelnic-2"{
    name="celnic-2"
    location="eastus"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    network_security_group_id="${azurerm_network_security_group.mycelnsg.id}"

    ip_configuration{
        name="mynicconfiguration"
        subnet_id="${azurerm_subnet.mycelsubnet.id}"
        private_ip_address_allocation="dynamic"
        public_ip_address_id="${azurerm_public_ip.mycelpublicip-2.id}"
    }
    tags{
        environmet="linux"
    }
}
resource    "azurerm_network_interface" "mycelnic-3"{
    name="celnic-3"
    location="eastus"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    network_security_group_id="${azurerm_network_security_group.mycelnsg.id}"

    ip_configuration{
        name="mynicconfiguration"
        subnet_id="${azurerm_subnet.mycelsubnet.id}"
        private_ip_address_allocation="dynamic"
        public_ip_address_id="${azurerm_public_ip.mycelpublicip-3.id}"
    }
    tags{
        environmet="linux"
    }
}

locals {
  storage_account_base_uri = "${azurerm_storage_account.mycelstorageaccount.primary_blob_endpoint}${azurerm_storage_container.disks.name}"
}
resource "azurerm_virtual_machine" "mycelvm-2" {
    name                  = "celVM-2"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.mycelgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.mycelnic-2.id}"]
    #vm_size               = "Standard_DS1_v2"
	vm_size               = "Standard_B2s"
    
    #this means the OS Disk will be deleted when Terraform destroys the Virtual Machine
    
    delete_os_disk_on_termination=true

  storage_os_disk {
    name          = "osdisk"
    vhd_uri       = "${local.storage_account_base_uri}/osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk1"
    vhd_uri       = "${local.storage_account_base_uri}/datadisk1.vhd"
    disk_size_gb  = "1023"
    create_option = "Empty"
    lun           = 0
  }

    storage_image_reference {
        publisher = "MicrosoftWindowsDesktop"
        offer     = "Windows-10"
        sku       = "RS3-Pro"
        version   = "latest"
    }

    os_profile {
        computer_name  = "node"
        admin_username = "azureuser"
        admin_password="celstream$456"
    }

  os_profile_windows_config {}

    tags {
        environment = "windows"
    }
}

