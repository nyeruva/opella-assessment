Deploying Azure Infrastructure based on Azure Virtual Network Module:

Module vnet is crated with the below folder structure. 
 

Call this module with ‘source = "./terraform/modules/vnet"’ by passing below arguments from root module. 
  vnet_name 
  resource_group_name
  location
  address_space 
  subnet_address_prefixes
  environment
  team
  nsg 

Below output values are generated from the vnet module:
vnet_id
vnet_name
subnet_ids

and these output values are used to create below azure resources
resource.azurerm_subnet.bastion_subnet
resource.azurerm_network_interface.nic

GitHub Actions Pipeline:
Pipeline is created to deploy Infra (both Development and Production) via Terraform.
