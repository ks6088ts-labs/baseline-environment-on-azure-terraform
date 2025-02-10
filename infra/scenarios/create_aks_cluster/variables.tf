# ---
# Common variables
# ---
variable "name" {
  description = "Specifies the name"
  type        = string
  default     = "createakscluster"
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
    scenario = "create_aks_cluster"
  }
}

# ---
# Feature flags
# ---
variable "create_ingress_nginx" {
  description = "Specifies whether to create Ingress NGINX Controller"
  type        = bool
  default     = false
}

variable "create_kube_prometheus_stack" {
  description = "Specifies whether to create kube-prometheus-stack"
  type        = bool
  default     = false
}

variable "create_argo_cd" {
  description = "Specifies whether to create Argo CD"
  type        = bool
  default     = false
}

variable "create_argo_workflows" {
  description = "Specifies whether to create Argo Workflows"
  type        = bool
  default     = false
}

variable "create_open_webui" {
  description = "Specifies whether to create Open WebUI"
  type        = bool
  default     = true
}
