module "acr" {

  source = "../.."

  registry_name       = "myregistry-acr"
  location            = "francecentral"
  resource_group_name = "default"

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
