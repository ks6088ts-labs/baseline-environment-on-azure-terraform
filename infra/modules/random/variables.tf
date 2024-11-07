variable "length" {
  description = "Specifies the length of the random string"
  type        = number
  default     = 5
}

variable "special" {
  description = "Specifies whether special characters are allowed in the random string"
  type        = bool
  default     = false
}

variable "upper" {
  description = "Specifies whether uppercase characters are allowed in the random string"
  type        = bool
  default     = false
}
