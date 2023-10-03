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
  dynamic "identity" {
    for_each = var.identities
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
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

  depends_on = [
    azurerm_container_registry.acr
  ]
}

resource "azurerm_container_registry_token" "this" {
  for_each                = var.scope_map != null ? { for k, v in var.scope_map : k => v if v != null } : {}
  name                    = format("%s", "${each.key}-token")
  resource_group_name     = var.resource_group_name
  container_registry_name = azurerm_container_registry.acr.name
  scope_map_id            = azurerm_container_registry_scope_map.this[each.key].id
  enabled                 = true

  depends_on = [
    azurerm_container_registry_scope_map.this
  ]
}

resource "azurerm_container_registry_token_password" "this" {
  for_each                    = var.scope_map != null ? { for k, v in var.scope_map : k => v if v != null } : {}
  container_registry_token_id = azurerm_container_registry_token.this[each.key].id

  password1 {

  }
  depends_on = [
    azurerm_container_registry.acr
  ]
}

resource "azurerm_private_endpoint" "this" {
  location            = var.location
  name                = format("%s", "${var.registry_name}-acr-pe")
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = "acrprivatelink"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
  }
}

resource "azurerm_management_lock" "this" {
  count      = var.instance_lock ? 1 : 0
  name       = format("%s-mg-lock", azurerm_container_registry.acr.name)
  scope      = azurerm_container_registry.acr.id
  lock_level = "CanNotDelete"
  notes      = "This is a security mechanism to prevent accidental deletion. Deleting a acr cluster drops all container registries."
}
