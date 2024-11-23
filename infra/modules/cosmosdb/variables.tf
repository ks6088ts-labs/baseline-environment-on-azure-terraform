variable "name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "Specifies the location for the resource group"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the resource group"
  type        = map(any)
  default     = {}
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "throughput" {
  type        = number
  default     = 400
  description = "Cosmos db database throughput"
  validation {
    condition     = var.throughput >= 400 && var.throughput <= 1000000
    error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.throughput % 100 == 0
    error_message = "Cosmos db throughput should be in increments of 100."
  }
}
