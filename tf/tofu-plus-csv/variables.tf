variable "route_table_name" {
  description = "The name of the route table"
  type        = string

}

variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "eastus"
}