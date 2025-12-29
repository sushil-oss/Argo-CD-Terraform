terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
    features {}
    subscription_id = "6c750392-d85d-41e6-a2be-4dc4ddc9d11d"
}
