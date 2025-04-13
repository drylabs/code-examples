terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {
  }

  #subscription_id = "AZ SUBSCRIPTION ID"
}
