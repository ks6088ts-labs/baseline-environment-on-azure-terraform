run "validate_location" {
  command = plan

  variables {
    location = "japanwest"
  }

  assert {
    condition     = module.resource_group.location == "japanwest"
    error_message = "Location of resource group is not as expected"
  }
  assert {
    condition     = module.log_analytics_workspace.location == "japanwest"
    error_message = "Location of log analytics workspace is not as expected"
  }
  assert {
    condition     = module.openai.location == "japanwest"
    error_message = "Location of openai resource is not as expected"
  }
}
