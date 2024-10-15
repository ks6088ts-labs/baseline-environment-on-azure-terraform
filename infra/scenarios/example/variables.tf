variable "name_prefix" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  default     = null
  type        = string
  nullable    = true
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "japaneast"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default = {
    scenario = "example"
  }
  type = map(string)
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  default     = "rg"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Specifies the name of the log analytics workspace"
  default     = "Workspace"
  type        = string
}

variable "solution_plan_map" {
  description = "Specifies solutions to deploy to log analytics workspace"
  default = {
    ContainerInsights = {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
  }
  type = map(any)
}

variable "openai_name" {
  description = "(Required) Specifies the name of the Azure OpenAI Service"
  type        = string
  default     = "OpenAi"
}

variable "openai_sku_name" {
  description = "(Optional) Specifies the sku name for the Azure OpenAI Service"
  type        = string
  default     = "S0"
}

variable "openai_custom_subdomain_name" {
  description = "(Optional) Specifies the custom subdomain name of the Azure OpenAI Service"
  type        = string
  nullable    = true
  default     = ""
}

variable "openai_public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed for the Azure OpenAI Service"
  type        = bool
  default     = true
}

variable "openai_deployments" {
  description = "(Optional) Specifies the deployments of the Azure OpenAI Service"
  type = list(object({
    name = string
    model = object({
      name    = string
      version = string
    })
    rai_policy_name = string
  }))
  default = [
    {
      name = "gpt-35-turbo"
      model = {
        name    = "gpt-35-turbo"
        version = "0613"
      }
      rai_policy_name = ""
    },
    {
      name = "text-embedding-ada-002"
      model = {
        name    = "text-embedding-ada-002"
        version = "2"
      }
      rai_policy_name = ""
    }
  ]
}
