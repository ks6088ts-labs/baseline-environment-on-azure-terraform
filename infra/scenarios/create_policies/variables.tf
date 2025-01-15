variable "name" {
  description = "Specifies the policy assignment name"
  type        = string
  default     = "Audit VMs that do not use managed disks"
}

variable "policy_definition_id" {
  description = "Specifies the policy definition id"
  type        = string
  default     = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
}
