variable "name" {
  description = "Specifies the Azure AI Foundry name."
  type        = string
  default     = "aifoundry"
}

variable "location" {
  description = "Specifies the location"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default = {
    scenario = "create_ai_foundry"
  }
}
