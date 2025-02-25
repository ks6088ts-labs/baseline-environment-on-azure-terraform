variable "name" {
  description = "Specifies the name"
  type        = string
  default     = "playgrounds"
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
    scenario = "playgrounds"
  }
}
