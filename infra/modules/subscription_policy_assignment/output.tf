output "id" {
  value       = azurerm_subscription_policy_assignment.subscription_policy_assignment.id
  description = "Specifies the resource id of the subscription policy assignment"
}

output "name" {
  value       = azurerm_subscription_policy_assignment.subscription_policy_assignment.name
  description = "Specifies the name of the subscription policy assignment"
}
