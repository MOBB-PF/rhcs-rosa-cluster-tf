data "aws_caller_identity" "current" {}

data "rhcs_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix  = var.account_role_prefix
}

data "rhcs_policies" "all_policies" {}

data "rhcs_versions" "all" {}
