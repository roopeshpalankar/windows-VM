resource "azurerm_virtual_machine" "mycentos" {
    name                  = "celVM-linux"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.mycelgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.mycelnic-3.id}"]
    #vm_size               = "Standard_DS1_v2"
	vm_size               = "Standard_B2s"

    storage_os_disk {
    name          = "osdisk_linux"
    vhd_uri       = "${local.storage_account_base_uri}/osdisk_linux.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }

    os_profile {
        computer_name  = "node"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRllfziS3xaYfL2E6fHLcNxh1QXsLg5iYnn7tFqhXGnDDrelJrzXXy5+Vqu6LBwtmxtY9YH6EIWrFvpiifiJh1UtPh4uXFwxgH6CgDF6DcDGzF0cdnpfUneF7IElGUYe05VQG3R4Av9fjFjX3jqv6WehMr0X9AP3/TzZsT/jwcUhgxcLQ9XSmvEUbo/u5ZIJUQtyxacVmUXMh0RwK+HbvKwr033ZsheXyiynmRe1kPWmr8m9o3H5YDSXfc/WqchfCfFW1zQIGQ44f58+OfIb83iKXDvrYq0rVaPCL7h9Wfer2Fb8zjYA6mxWBogOESJfhem8X/EKYgiYDF428Royvh"
        }
    }
    tags {
        environment = "linux"
    }
}
