# Azure container registry module

A Terraform module which creates Azure Container Registry

## Usage

```hcl 
module "acr" {

  source = "../.."

  registry_name       = "myregistry-acr"
  location            = "francecentral"
  resource_group_name = "default"
  admin_enable        = false

  georeplications = [
    {
      location                = "France Central"
      zone_redundancy_enabled = true
    },
    {
      location                = "Switzerland North"
      zone_redundancy_enabled = true
    }
  ]
}
```
