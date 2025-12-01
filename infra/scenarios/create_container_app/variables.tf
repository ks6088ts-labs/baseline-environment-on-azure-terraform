# General
variable "location" {
  description = "Azure リージョン"
  type        = string
  default     = "japaneast"
}

variable "resource_group_name" {
  description = "リソースグループ名"
  type        = string
  default     = "rg-create-container-app"
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

# Log Analytics Workspace
variable "log_analytics_workspace_name" {
  description = "Log Analytics ワークスペース名"
  type        = string
  default     = "law-create-container-app"
}

variable "log_analytics_retention_in_days" {
  description = "Log Analytics の保持日数"
  type        = number
  default     = 30
}

# Container App Environment
variable "container_app_environment_name" {
  description = "Container App Environment 名"
  type        = string
  default     = "cae-create-container-app"
}

# Container App
variable "container_app_name" {
  description = "Container App 名"
  type        = string
  default     = "ca-create-container-app"
}

variable "container_image" {
  description = "コンテナイメージ"
  type        = string
  default     = "ks6088ts/template-mcp-python:0.0.4"
}

variable "container_target_port" {
  description = "コンテナのターゲットポート"
  type        = number
  default     = 8000
}

variable "container_cpu" {
  description = "コンテナの CPU (コア数)"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "コンテナのメモリ"
  type        = string
  default     = "1Gi"
}

variable "container_min_replicas" {
  description = "最小レプリカ数"
  type        = number
  default     = 0
}

variable "container_max_replicas" {
  description = "最大レプリカ数"
  type        = number
  default     = 10
}

variable "container_command" {
  description = "コンテナのコマンド"
  type        = list(string)
  default = [
    "python",
  ]
}
variable "container_args" {
  description = "コンテナの引数"
  type        = list(string)
  default = [
    "scripts/mcp_runner.py",
    "quick-example",
    "--transport",
    "streamable-http",
  ]
}

variable "container_env_vars" {
  description = "コンテナの環境変数"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "MCP_PORT"
      value = "8000"
    },
    {
      name  = "MCP_HOST"
      value = "0.0.0.0"
    }
  ]
}
