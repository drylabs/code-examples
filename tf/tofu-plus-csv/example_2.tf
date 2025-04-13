locals {
  # We've included this inline to create a complete example, but in practice
  # this is more likely to be loaded from a file using the "file" function.
  csv_dns_zone_type_cname_drylabs_dev = <<-CSV
    name,type,ttl,records,docs
    dns1,CNAME,3600,drylabs.dev,n/a
    dns2,CNAME,3600,google.com,n/a
    app,CNAME,3600,lb-example.drylabs.dev,n/a
    app2,CNAME,3600,app2.drylabs.dev.cdn.cloudflare.net,n/a
  CSV

  csv_dns_zone_type_a_drylabs_dev = <<-CSV
    name,type,ttl,records,docs
    lb-example,a,3600,1.1.1.1,n/a
  CSV

  dns_zone_type_cname_drylabs_dev = csvdecode(local.csv_dns_zone_type_cname_drylabs_dev)
  dns_zone_type_a_drylabs_dev     = csvdecode(local.csv_dns_zone_type_a_drylabs_dev)
}

resource "azurerm_dns_zone" "main" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_dns_cname_record" "main" {
  for_each            = { for k in local.dns_zone_type_cname_drylabs_dev : k.name => k }
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name

  name   = each.value.name
  record = each.value.records
  ttl    = each.value.ttl

}

resource "azurerm_dns_a_record" "main" {
  for_each            = { for k in local.dns_zone_type_a_drylabs_dev : k.name => k }
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name

  name    = each.value.name
  records = [each.value.records]
  ttl     = each.value.ttl

}