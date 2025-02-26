variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "Specifies the location of the Azure Kubernetes Service"
  type        = string
}

variable "name" {
  description = "Specifies the name of the Azure Kubernetes Service"
  type        = string
}

variable "tags" {
  description = "Specifies the tags of the Azure Kubernetes Service"
  type        = map(any)
  default     = {}
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "The size of the VMs in the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
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
  default     = false
}

variable "create_kubecost" {
  description = "Specifies whether to create Kubecost"
  type        = bool
  default     = false
}
