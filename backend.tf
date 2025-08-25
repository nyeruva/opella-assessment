terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform_State_RG"
    storage_account_name = "terraformtfstate01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
