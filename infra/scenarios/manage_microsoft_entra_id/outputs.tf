output "users" {
  value       = azuread_user.users
  description = "created users"
  sensitive   = true
}

output "groups" {
  value       = azuread_group.groups
  description = "created groups"
}

output "group_members" {
  value       = azuread_group_member.group_members
  description = "created group members"
}
