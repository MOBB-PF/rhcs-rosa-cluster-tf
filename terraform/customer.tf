
# Customer onboarding of helm chart.

resource "null_resource" "customer" {
  for_each = var.customers
  provisioner "local-exec" {
    command = "scripts/customer_onboarding.sh >> output.log 2>&1"
    environment = {
      secret                      = "${var.cluster_name}-${var.env}-credentials"
      AWS_ACCESS_KEY_ID           = var.AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY       = var.AWS_SECRET_ACCESS_KEY
      AWS_DEFAULT_REGION          = var.AWS_DEFAULT_REGION
      wait_on                     = null_resource.seed[0].id
      helm_token                  = var.helm_token
      customer_name               = try(each.value.name, null)
      customer_repo               = try(each.value.git_repository, null)
      customer_helm_repo          = var.customer_chart.helm_repo
      customer_helm_chart         = var.customer_chart.helm_chart
      customer_helm_chart_version = var.customer_chart.helm_chart_version
    }
  }
}