resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  dynamic "georeplications" {
    for_each = var.georeplications

    content {
      location                = georeplications.value["location"]
      zone_redundancy_enabled = georeplications.value["zone_redundancy_enabled"]
    }
  }

  tags = var.tags

}

resource "azurerm_container_registry_scope_map" "this" {
  for_each                = var.scope_map != null ? { for k, v in var.scope_map : k => v if v != null } : {}
  name                    = format("%s", each.key)
  resource_group_name     = var.resource_group_name
  container_registry_name = azurerm_container_registry.acr.name
  actions                 = each.value["actions"]
}

resource "azurerm_container_registry_token" "this" {
  for_each                = var.scope_map != null ? { for k, v in var.scope_map : k => v if v != null } : {}
  name                    = format("%s", "${each.key}-token")
  resource_group_name     = var.resource_group_name
  container_registry_name = azurerm_container_registry.acr.name
  scope_map_id            = element([for k in azurerm_container_registry_scope_map.this : k.id], 0)
  enabled                 = true
}

resource "azurerm_management_lock" "this" {
  count      = var.instance_lock ? 1 : 0
  name       = format("%s-mg-lock", azurerm_container_registry.acr.name)
  scope      = azurerm_container_registry.acr.id
  lock_level = "CanNotDelete"
  notes      = "This is a security mechanism to prevent accidental deletion. Deleting a acr cluster drops all container registries."
}


