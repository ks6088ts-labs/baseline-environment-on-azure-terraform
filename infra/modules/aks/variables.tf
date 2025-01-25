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
