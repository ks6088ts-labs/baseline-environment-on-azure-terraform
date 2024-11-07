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
    condition     = module.storage_account.location == "japanwest"
    error_message = "Location of resource group is not as expected"
  }
}
