resource "azurerm_storage_account" "mycelstorageaccount"{
    name="celstorageaccount"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    location = "eastus"
    account_replication_type = "LRS"
    account_tier = "Standard"
    tags {
        environment = "Terraform"
        }
}
resource "azurerm_storage_container" "disks"{
    name="vhds"
    resource_group_name="${azurerm_resource_group.mycelgroup.name}"
    storage_account_name="${azurerm_storage_account.mycelstorageaccount.name}"
    container_access_type="private"

}