resource "azurerm_resource_group" mycelgroup{
    name="celgroup"
    location="eastus"
    tags{
        environment="Windows"
    }
}