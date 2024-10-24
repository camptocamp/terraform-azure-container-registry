variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Location of resource(s)."
  type        = string
}

variable "registry_name" {
  description = "Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
  type        = string
}

variable "sku" {
  description = " The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Premium"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "identities" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Container Registry. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
  default     = null
  nullable    = true
  type = list(object({
    type         = string
    identity_ids = optional(list(string))
  }))
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "georeplications" {
  description = "A list of properties of the geo-replication blocks for this Container Registry. Only availiable for Premium SKU."

  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool, false)
  }))

  default = []
}

variable "scope_map" {
  description = "Manages an Azure Container Registry scope map. Scope Maps are a preview feature only available in Premium SKU Container registries."
  type = map(object({
    actions = list(string)
  }))
  default = null
}

variable "cache_rule" {
  description = "A list of properties of the cache rules blocks for this Container Registry."
  type = map(object({
    source_repo       = string
    target_repo       = string
    credential_set_id = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "instance_lock" {
  description = "If true, it’s not possible to remove the azure container registry"
  type        = bool
  default     = true
}
