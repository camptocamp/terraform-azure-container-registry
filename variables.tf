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