terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

data "azuread_domains" "default" {
  only_initial = true
}

locals {
  domain_name   = data.azuread_domains.default.domains[0].domain_name
  users         = csvdecode(file(var.file_users))
  groups        = csvdecode(file(var.file_groups))
  group_members = csvdecode(file(var.file_group_members))
}

resource "random_pet" "suffix" {
  length = 2
}

resource "azuread_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  user_principal_name = format(
    "%s%s-%s@%s",
    substr(lower(each.value.first_name), 0, 1),
    lower(each.value.last_name),
    random_pet.suffix.id,
    local.domain_name
  )

  password = format(
    "%s%s%s!",
    lower(each.value.last_name),
    substr(lower(each.value.first_name), 0, 1),
    length(each.value.first_name)
  )
  force_password_change = true

  display_name = "${each.value.first_name} ${each.value.last_name}"
  department   = each.value.department
  job_title    = each.value.job_title
}

resource "azuread_group" "groups" {
  for_each = { for group in local.groups : group.group_name => group }

  display_name     = each.value.group_name
  security_enabled = true
}

resource "azuread_group_member" "group_members" {
  for_each = { for idx, group_member in local.group_members : idx => group_member }

  group_object_id  = each.value.group_object_id
  member_object_id = each.value.member_object_id
}
