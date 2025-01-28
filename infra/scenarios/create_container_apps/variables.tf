variable "name" {
  description = "Specifies the name of the Azure Container Apps"
  type        = string
  default     = "container-app"
}

variable "location" {
  description = "Specifies the location of Azure Container Apps"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "Specifies the tags of the Azure Container Apps"
  type        = map(any)
  default     = {}
}

variable "image" {
  description = "Specifies the container image"
  type        = string
  default     = "nginx:latest"
}

variable "ingress_target_port" {
  description = "Specifies the target port of the ingress"
  type        = number
  default     = 80
}

variable "envs" {
  description = "Specifies the environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "hello"
      value = "world"
    },
    {
      name  = "hoge"
      value = "fuga"
    },
  ]
}
