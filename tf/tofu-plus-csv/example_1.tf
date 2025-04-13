# Here is a local value what sets the name 'vnet_routes' so we can call that multiple times later.
# The CSV file needs to be stored in the same location ${path.module} as the main.tf of whatever you call your file that contains the Route module.
locals {
  vnet_routes = csvdecode(file("${path.module}/vnet_routes.csv"))
}

resource "azurerm_route_table" "main" {
  name                = "rt-${var.route_table_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

resource "azurerm_route" "vnet_routes" {
  for_each            = { for routes in local.vnet_routes : routes.route_name => routes }
  route_table_name    = azurerm_route_table.main.name
  resource_group_name = azurerm_resource_group.main.name

  name                   = each.value.route_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = (each.value.next_hop_type == "VirtualAppliance") == true ? each.value.next_hop_ip : null

  depends_on = [azurerm_resource_group.main]
}

output "show_vnet_route" {
  value = local.vnet_routes
}