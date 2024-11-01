variable "file_users" {
  description = "path to csv file for users"
  default     = "users.csv"
  type        = string
}

variable "file_groups" {
  description = "path to csv file for groups"
  default     = "groups.csv"
  type        = string
}

variable "file_group_members" {
  description = "path to csv file for group/member lists"
  default     = "group_members.csv"
  type        = string
}
