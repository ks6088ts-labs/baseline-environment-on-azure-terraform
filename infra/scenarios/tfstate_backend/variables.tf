variable "name" {
  description = "Specifies the name"
  type        = string
  default     = "tfstatebackend"
}

variable "location" {
  description = "Specifies the location"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default = {
    scenario = "tfstate_backend"
  }
}
