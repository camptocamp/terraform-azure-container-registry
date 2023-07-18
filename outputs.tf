output "registry_id" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.acr.id
}

output "registry_name" {
  description = "The name of the Container Registry."
  value       = azurerm_container_registry.acr.name
}

output "registry_login_server" {
  description = "The login server of the Container Registry."
  value       = azurerm_container_registry.acr.login_server
}

output "registry_admin_username" {
  description = "The admin username of the Container Registry."
  value       = azurerm_container_registry.acr.admin_username
}

output "registry_admin_password" {
  description = "The admin username of the Container Registry."
  sensitive   = true
  value       = azurerm_container_registry.acr.admin_password
}

output "registry_token_password" {
  sensitive = true
  value = azurerm_container_registry_token_password.this.*
}
